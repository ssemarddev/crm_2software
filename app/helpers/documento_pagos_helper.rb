module DocumentoPagosHelper
  def semaphore_color(documento_pago)
    return 'success' if documento_pago.pago.size == 0 
    case (Time.now.to_date - documento_pago.pago.first.created_at.to_date).to_i
    when 1..15
      'success'
    when 16..30
      'warning'
    when 31..100000000
      'danger'
    else
      'none'
    end
  end

  def semaphore_days(documento_pago)
    return 0 if documento_pago.pago.size == 0 
    (Time.now.to_date - documento_pago.pago.first.created_at.to_date).to_i
  end
end
