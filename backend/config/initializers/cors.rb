Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://127.0.0.1:3001' # Next.jsを動作させているアドレスとポート番号

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
