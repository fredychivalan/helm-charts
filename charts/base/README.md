# Base Library Chart

A [Helm chart library](https://helm.sh/docs/topics/library_charts/#helm) for grouping common logic and Kubernetes object definitions for reuse across application charts.

---

## Introduction

The `base` chart is conceived as a fundamental **Helm chart library**. Its primary objective is to encapsulate and organize common logic and Kubernetes object definitions (such as Deployments, Services, Ingress, etc.) that are typically recurring in the implementation of various applications.

By consolidating this logic into a single library chart, **reusability** and **standardization** are promoted across multiple application charts. This reduces code duplication, simplifies maintenance, and facilitates the consistent application of configurations and deployment patterns within a Kubernetes environment. Application charts can depend on `base` and incorporate its functionality, customizing only those aspects that are specific to the application in question.

## Prerequisites

To use this Helm chart library, the following components are required to be installed and configured:

* **Kubernetes**: A running Kubernetes cluster (version 1.18 or higher recommended).
* **Helm**: The Helm command-line tool (version 3.0.0 or higher).

Ensure your `kubectl` client is configured to communicate with the desired Kubernetes cluster.

## How to Use as a Dependency

The `base` chart is designed to be included as a **dependency** in other application charts. To incorporate the logic and resources defined in `base` within your own chart, you must declare the dependency in the `Chart.yaml` file of your application chart.

Add the following `dependencies` section to your `Chart.yaml`:

```yaml
dependencies:
- name: base
  repository: "https://fredychivalan.github.io/helm-charts"
  version: 1.1.0 # Use the desired version of the base library
```