Rails.application.routes.draw do
  resources :bancos
  resources :calidads
  resources :ruta
  resources :detallecajas
  resources :aparatos
  resources :pagos
  resources :empresas
  resources :bodegausers
  resources :estadortackings
  resources :trackings
  resources :estados
  resources :cajas
  resources :tareas
  resources :subproyectos
  resources :proyectos
  resources :tarjeta_creditos
  resources :documento_pagos
  resources :detalle_documentos
  resources :movimiento_productos
  resources :documentos
  resources :tipo_documentos
  resources :detalle_medidas
  resources :usuarios
#get 'admin/index'
#get 'sessions/new'

  resources :productos
  resources :auto_sats
  resources :role_usuarios
  resources :bodegas
  resources :cliente_proveedors
  resources :tipo_pagos
  resources :medidas
  resources :tipo_productos
  resources :marcas
  resources :opcion_roles
  resources :opcions
  resources :roles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/', to: 'user_login#login', as: 'login'
  get 'logout', to: 'sessions#logout'
  get 'sessions/destroy'
  get 'sessions/create'
  get 'admin'           => 'admin#index'
  get 'puntoventa'      => 'puntoventa#new'
  get 'puntoventaMiniSuper' => 'puntoventa#puntoventaMiniSuper'
  get 'puntocompra'     => 'puntoventa#compra'
  get 'envio_bodega'    => 'puntoventa#envios'
  get 'miEmpresa'       => 'empresas#edit'

  get 'cliente_proveedor_tipo/:Tipo' => 'cliente_proveedors#index'
  get 'avanceProyecto'  => 'proyectos#avanceProyecto'
  get  'chooseBodega'   => 'bodegausers#chooseBodega'
  get 'saveChoose'      => 'bodegausers#saveChoose'
  get 'newCliente'      => 'cliente_proveedors#newLayoutFalse'
  get 'cuotas/:id'      => 'pagos#index'
  post 'addDescripcion' => 'tareas#updateDescripcion'
  post 'finalizarTarea' => 'tareas#finalizarTarea'

  controller :documentos do
    get 'writeExcel'      => :writeExcel
    get 'getDoctosByUserAndDate' => :getDoctosByUserAndDate
    get 'procesamientoDocumentos' => :procesamientoDocumentos
    get 'procesamientoDocumentosBodega' => :procesamientoDocumentosBodega
    get 'despachar'       => :despachar
    get 'despacharPorRuta' => :despacharPorRuta
    get 'cotizaciones' => :cotizaciones
  end

  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    delete 'logout' => :destroy
  end

  controller :route_api do
    post 'loginApi.json'=> :loginApi
    get  'clientsByRoute.json'=> :findClientsByRoute
    get  'listDefinedRoutes.json'=> :listDefinedRoutes
    get  'listProducts.json'=> :listProducts
    get  'listSizesByProduct.json'=> :listSizesByProduct
    post 'saveRouteOrder.json'  => :saveRouteOrder
  end

  controller :outsideviews do
    get    'trackingView'         => :trackingView
    get    'trk'                  => :trackingView
    post 'createTrackingApi.json' => :createTrackingApi
    post 'updateTrackingStateApi.json' => :updateTrackingStateApi
  end

  controller :cart_shops do
    get    'online_catalog'       => :products_view
    get    'product_details/:id'  => :product_details
    get    'productosView2'       => :productosView2
    post   'saveCartOrder'        => :saveCartOrder
    get    'cart_shop_login'      => :cart_shop_login
    get    'login_as_client'      => :login_as_client
    post 'save_catalog_restock' => :save_catalog_restock
  end

  #get 'saveMovProduct' => 'MovimientoProductos#new'
  controller :puntoventa do
    post 'findProduct'              => :findProduct
    post 'findBodegas'              => :findBodegas
    post 'findMedida'               => :findMedida
    post 'findDetalleMedida'        => :findDetalleMedida
    post 'saveMovProduct'           => :saveMovProduct
    post 'findCliente'              => :findCliente
    post 'findProveedor'            => :findProveedor
    post 'findFactura'              => :findFactura
    post 'findTipoPago'             => :findTipoPago
    post 'saveOrder'                => :saveOrder
    post 'unloadOrder'              => :unloadOrder
    post 'unloadMovProd'            => :unloadMovProd
    post 'findProductosByProvider'  => :findProductoByProvider
    get  'print/:id'                => :printDocumento, as: :print
    get  'reporteExistenciasBodega' => :reporteExistenciasBodega
    get  'reporteVentasYCompras'    => :reporteVentasYCompras
    get  'productoStock'            => :getStockProduct
    get  'cotizacion/:id'           => :cotizacion, as: :cotizacion
  end

  root 'sessions#create', as: 'index'
  match "*path" => redirect("/admin"), :via => [:get]

end
