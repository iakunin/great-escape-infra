output "image-urls" {
  value = {
    admin-ui = data.google_container_registry_image.admin-ui.image_url
    backend  = data.google_container_registry_image.backend.image_url
  }
}
