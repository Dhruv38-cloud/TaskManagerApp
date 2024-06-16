// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "bootstrap"
import { Turbo } from "@hotwired/turbo-rails"
import Rails from "@rails/ujs"

Rails.start()
Turbo.start()
import "@hotwired/turbo-rails"
import "controllers"
