CREATE OR REPLACE PROCEDURE adl_sispa_traficoout_imsi(pais NUMBER := 502,tipocdr NUMBER := 1 , fecha VARCHAR2 := NULL) AUTHID CURRENT_USER IS
numTransact     number;
v_periodo       varchar(10);
v_fecha         varchar(10);
sQuery          varchar2(5000);
cdr_name        varchar(50);
table_name      varchar(50);
table_name_imei varchar(50);
category        varchar(5000);
--NUMERO_PRUEBA number;
--pais        number;
--tipocdr     number;
BEGIN

   select trunc(dbms_random.value(100000000000, 999999999999)) into numTransact from dual;

   v_periodo  := to_char(sysdate-1,'YYYYMM');
   IF fecha IS NULL THEN
    v_fecha    := to_char(sysdate-1,'YYYYMMDD');
   ELSE
    v_fecha    := fecha;
   END IF;

   --pais       := 502;
   --tipocdr    := 1;


   CASE
     WHEN tipocdr = 1 THEN
      cdr_name        := 'llamada';
      category        := '21,22,23';
     WHEN tipocdr = 2 THEN
      cdr_name        := 'sms';
      category        := '6,12,21';
     WHEN tipocdr = 23 THEN
      cdr_name        := 'datos';
      category        := '6,7,8,9,10';
     WHEN tipocdr = 4 THEN
      cdr_name        := 'paquete';
      category        := '21,22,23,6,7,8,9,10,12';
     ELSE
      cdr_name        := 'llamada';
      --tipocdr         := 1;
   END CASE;
   /*CASE
     WHEN pais = 502 THEN
      table_name_imei := 'dw_tb_movil_saliente_gt';--Guatemala
     WHEN pais = 503 THEN
      table_name_imei := 'dw_tb_movil_saliente_sv';--El Salvador
     WHEN pais = 504 THEN
      table_name_imei := 'dw_tb_movil_saliente_hn';--Honduras
     WHEN pais = 505 THEN
      table_name_imei := 'dw_tb_movil_saliente_ni';--Nicaragua
     WHEN pais = 506 THEN
      table_name_imei := 'dw_tb_movil_saliente_cr';--Costa rica
     ELSE
      table_name_imei := 'dw_tb_movil_saliente_gt';--Guatemala por defecto
      --pais            := 502;
   END CASE;
   */

   table_name := 'adlc_traficoout_'||cdr_name||'_'||pais||'_2';
   --NUMERO_PRUEBA := '50241615587';
    /*========================================================================
    01 SE CREA LA TABLA DE TR�FICO DE LLAMADAS
    =========================================================================*/

    BEGIN
       EXECUTE IMMEDIATE 'drop table '||table_name||'';
    EXCEPTION
       WHEN OTHERS THEN
          IF SQLCODE != -942 THEN
             RAISE;
          END IF;
    END;
IF tipocdr=1 or tipocdr=2 or tipocdr = 23 THEN --LLAMADAS -- SMS -- DATOS
    sQuery := '
    CREATE TABLE '||table_name||'
    AS
    SELECT
        /*+index(a, IDX_NUMERO)*/a.num_origen,
        b.imsi,
        max(b.cdrdate) as fecha,
        sum(b.t_duracion) as duracion,
        sum(b.cta_principaldelta) as costo
    FROM
        prepago.dw_tb_detalle_altas@dw a LEFT JOIN
        prepago.dw_tb_ods_prepago@dw b ON /*+index(a, IDX_NUMERO)*/a.num_origen = /*+index(b, DW_IDX_ODS_02)*/b.num_origen
    WHERE
            /*+index(a, IDX_DETALLE_ALTAS)*/a.idpais    = '||pais||'
        --AND
          --  a.idperiodo = '||v_periodo||'
        --AND
          --  b.idperiodo = '||v_periodo||'
        AND
            /*+index(b, DW_IDX_ODS_01)*/b.IDCALENDARIO = '||v_fecha||'
        AND
            /*+index(b, DW_IDX_ODS_01)*/b.idtipocdr = '||tipocdr||'
        AND
            b.idpais    = '||pais||'
        AND
            b.ideventcategory NOT IN('||category||')
        --AND rownum < 5000
        GROUP BY
            a.num_origen,
            b.imsi
            ';
ELSE --PAQUETES

sQuery := '
CREATE TABLE '||table_name||'
AS
SELECT
    /*+index(a, IDX_NUMERO)*/a.num_origen,
    b.imsi,
    max(b.cdrdate) as fecha,
    sum(b.t_duracion) as duracion,
    sum(b.cta_principaldelta) as costo
FROM
    prepago.dw_tb_detalle_altas@dw a LEFT JOIN
    prepago.dw_tb_ods_prepago@dw b ON /*+index(a, IDX_NUMERO)*/a.num_origen = /*+index(b, DW_IDX_ODS_02)*/b.num_origen
WHERE
        /*+index(a, IDX_DETALLE_ALTAS)*/a.idpais    = '||pais||'
    --AND
      --  a.idperiodo = '||v_periodo||'
    --AND
      --  b.idperiodo = '||v_periodo||'
    AND
        /*+index(b, DW_IDX_ODS_01)*/b.IDCALENDARIO = '||v_fecha||'
    AND
        b.idpais    = '||pais||'
    AND
        b.ideventcategory IN('||category||')
    --AND rownum < 500
    GROUP BY
        a.num_origen,
        b.imsi';
END IF;
    DBMS_OUTPUT.PUT_LINE(sQuery);
    EXECUTE IMMEDIATE sQuery;

    DBMS_OUTPUT.PUT_LINE('Se creo la tabla '||table_name||'');

    sQuery := 'insert into log_zdl_sispaco values (sysdate,1,'||numTransact||',''TRAFICO-OUT-LLAMADA-'||pais||''',''Creacion de tabla adlc_traficoout_llamada_gt'')';

    --EXECUTE IMMEDIATE sQuery;

    COMMIT;
END adl_sispa_traficoout_imsi;
