#!/usr/bin/python3
import os
import yaml

def clean_kube_config(config_path="~/.kube/config"):
    """
    Cleans invalid entries (clusters, contexts, and users) from the Kubernetes config file.

    :param config_path: Path to the kubeconfig file
    """
    config_path = os.path.expanduser(config_path)

    # Load the config file
    try:
        with open(config_path, "r") as file:
            kube_config = yaml.safe_load(file)
    except FileNotFoundError:
        print(f"Config file not found at {config_path}")
        return
    except yaml.YAMLError as e:
        print(f"Error parsing YAML file: {e}")
        return

    original_config = kube_config.copy()

    # Verify clusters
    valid_clusters = [cluster for cluster in kube_config.get("clusters", []) if validate_cluster(cluster)]
    kube_config["clusters"] = valid_clusters

    # Verify users
    valid_users = [user for user in kube_config.get("users", []) if validate_user(user)]
    kube_config["users"] = valid_users

    # Verify contexts
    valid_contexts = [context for context in kube_config.get("contexts", []) if validate_context(context, valid_clusters, valid_users)]
    kube_config["contexts"] = valid_contexts

    # Remove invalid current-context if it doesn't exist in valid contexts
    if kube_config.get("current-context") not in [ctx["name"] for ctx in valid_contexts]:
        kube_config["current-context"] = None

    # Save the cleaned configuration
    if kube_config != original_config:
        with open(config_path, "w") as file:
            yaml.dump(kube_config, file)
        print(f"Invalid entries removed. Config file cleaned at {config_path}")
    else:
        print("No invalid entries found. Config file is clean.")

def validate_cluster(cluster):
    """
    Validates a cluster entry.
    """
    required_fields = ["name", "cluster"]
    return all(field in cluster for field in required_fields)

def validate_user(user):
    """
    Validates a user entry.
    """
    required_fields = ["name", "user"]
    return all(field in user for field in required_fields)

def validate_context(context, valid_clusters, valid_users):
    """
    Validates a context entry against valid clusters and users.
    """
    cluster_names = [cluster["name"] for cluster in valid_clusters]
    user_names = [user["name"] for user in valid_users]

    return (
        "name" in context and
        "context" in context and
        context["context"].get("cluster") in cluster_names and
        context["context"].get("user") in user_names
    )

# Example usage
if __name__ == "__main__":
    clean_kube_config()

