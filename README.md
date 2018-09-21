# Kubectl and Helm clients

Alpine based Docker image that includes Kubectl, Helm and Helmfile.

This can be used interactively, or as part of a CI/CD system.
To use this run the image with your Kubernetes connection file, for example:

    docker run -it --rm -v ~/.kube/:/home/kube/.kube/:ro kube-helm-docker


## Version compatibility

Kubectl has good backwards compatibility so it is safe to connect to older clusters.

Helm should be compatible between minor releases e.g. `2.9.*`.
You will need to rebuild the image for other Helm versions.

Helmfile is a wrapper around Helm.
The latest version should be compatible with older versions of Helm.
