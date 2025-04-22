# Application Helm chart

Helm chart for general applications

---

## Introduction

The `application` Helm chart provides a flexible structure for the deployment of general-purpose applications in Kubernetes. It has been designed to support diverse deployment scenarios through two primary internal structures: `application` and `backend`.

Each of these structures encapsulates a common and essential set of Kubernetes objects, including **Deployment**, **Horizontal Pod Autoscaler (HPA)**, **Ingress**, **Pod Disruption Budget (PDB)**, **Service**, and **Service Account**. This modular design allows the chart to be adapted to a wide variety of workloads without requiring specific configurations based on the programming language or framework used by the application.

## Motivation and Problem Solved

Historically, the need to deploy applications developed in various languages and frameworks (such as Python, Node.js, .NET, ASP.NET, Go, among others) often resulted in the development and maintenance of bespoke Helm charts for each technology. This approach presented significant challenges regarding consistency, standardization, and maintenance overhead.

To address this issue, the `application` chart has been developed. This chart was built by leveraging and reusing the logic and templates provided by the `base` Helm chart library, thereby promoting efficiency and uniformity. The objective is to offer a unified deployment solution that allows deploying diverse applications in Kubernetes without being coupled to a main language or framework, simplifying the CI/CD process and application management.

## Installation

To deploy the `application` chart, follow these steps:

**1. Add the Helm Repository**

First, add the Helm repository where the chart is hosted to your Helm configuration:

```sh
helm repo add apps https://fredychivalan.github.io/helm-charts
```

After adding the repository, it is recommended to update your local repository cache:

```sh
helm repo update
```

**2. Discover Available Versions**

To see the available versions of the `application` chart in the added repository, you can use the `helm search repo` command:

```sh
helm search repo apps/application --versions
```

This will list all published versions of the chart, allowing you to choose a specific one for installation.

**3. Install the Chart**

Once the repository is added and updated, you can install the chart using the `helm install` command. You should specify a name for your release and the chart reference (`apps/application`). It is a recommended practice to specify a chart version for predictable deployments. You can also specify the Kubernetes namespace where the chart should be installed.

To install a specific version of the chart:

```sh
helm install [release-name] apps/application --version [chart-version] --namespace [namespace]
```

Replace `[release-name]` with a unique name for your deployment, `[chart-version]` with the desired version from the `helm search repo` output, and `[namespace]` with the target Kubernetes namespace.

For example:

```sh
helm install my-app apps/application --version 1.1.1 --namespace default
```

You can customize the deployment by providing a custom `values.yaml` file using the `-f` flag, which is crucial for configuring aspects like image, resources, ingress, etc.:

```sh
helm install [release-name] apps/application --version [chart-version] --namespace [namespace] -f your-custom-values.yaml
```
