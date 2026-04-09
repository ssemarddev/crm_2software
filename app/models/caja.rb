class Caja < ApplicationRecord
  belongs_to :usuario, class_name: 'Usuario'
  has_many :detallecajas, class_name: 'Detallecaja', dependent: :destroy

  validates :Nombre, presence: true
  validates :usuario_id, presence: true
  validates :InicialEfectivo, presence: true

  validate :solo_una_caja_abierta_por_usuario, on: :create

  scope :abiertas, -> { where(Estado: [false, nil]) }
  scope :cerradas, -> { where(Estado: true) }

  before_save do
    self.creado = Time.now.strftime("%Y-%m-%d")
    self.actualizado = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  before_update do
    self.actualizado = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def abierta?
    Estado != true
  end

  def cerrada?
    Estado == true
  end

  private

  def solo_una_caja_abierta_por_usuario
    return unless usuario_id.present?

    abierta_existente = Caja.where(usuario_id: usuario_id)
                            .where(Estado: [false, nil])

    if persisted?
      abierta_existente = abierta_existente.where.not(id: id)
    end

    if abierta_existente.exists?
      errors.add(:base, 'El usuario ya tiene una caja abierta.')
    end
  end
end