ENV['CASHIER_ENV'] ||= 'development'

CONFIG = {
  'development' => {
    log_file: 'log/cashier.log',
    promotions_file: 'config/promotions.yml'
  },
  'test' => {
    log_file: 'log/cashier_test.log',
    promotions_file: 'config/promotions_test.yml'
  }
}[ENV.fetch('CASHIER_ENV', nil)]
