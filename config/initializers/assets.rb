# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( jquery.js )
Rails.application.config.assets.precompile += %w( jquery_ujs.js )
Rails.application.config.assets.precompile += %w( jquery.metisMenu.js )
#Rails.application.config.assets.precompile += %w( jquery.dataTables.js )
Rails.application.config.assets.precompile += %w( helpers.js )
Rails.application.config.assets.precompile += %w( custom.js )
Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( font-awesome.css )
Rails.application.config.assets.precompile += %w( custom.css )
Rails.application.config.assets.precompile += %w( font-awesome.min.css )
Rails.application.config.assets.precompile += %w( reporte_documento.css )
Rails.application.config.assets.precompile += %w( tracking2.css )
Rails.application.config.assets.precompile += %w( user_login.css )
Rails.application.config.assets.precompile += %w( scaffolds.scss )
Rails.application.config.assets.precompile += %w( out_of_session_views.css )
Rails.application.config.assets.precompile += %w( productos.css )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# require mailers.js
# require_tree
