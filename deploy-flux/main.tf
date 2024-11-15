resource "local_file" "kubeconfig" {
  depends_on = [ data.onepassword_item.kubeconfig ]
    content = data.onepassword_item.kubeconfig.note_value
    filename = "${path.cwd}/k3s.yaml"
}

resource "github_repository" "this" {
  depends_on = [local_file.kubeconfig]
  name        = var.github_repository
  description = var.github_repository
  visibility  = "private"
  auto_init   = true
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository.this]
  embedded_manifests = true
  path               = "clusters/"
}
