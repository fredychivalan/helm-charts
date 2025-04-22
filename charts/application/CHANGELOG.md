# Changelog

## [1.1.1] - 2025-04-22
### Added
- It groups objects into two structures: `application` and `backend`, each of which can create a series of `Kubernetes` objects to deploy apps.
- Add a `backend` structure with (`deployment` `hpa`, `ingress`, `pdb`, `service` and `serviceaccount`)
- Add `PodDisruptionBudget`, using functions inherited from the helm chart "base" library, to the application group.
- It inherits functions from the Helm Chart library called **"base"** to create `Kubernetes` objects.

### Changed
- Modifies the creation of `HPAs`, using functions inherited from the Helm Chart **"base"** library, for the application group.
- Modifies the `deployment` creation, using functions inherited from the helm chart **"base"** library, for the application group.

---

## [0.1.1-v1beta1] - 2025-03-21
### Added
- Use **global** configurations to affect behavior and configuration parameters for applications.
- Create a helm chart application with the Kubernetes objects (`deployment`, `hpa`, `ingress`, `service`, `serviceaccount`).