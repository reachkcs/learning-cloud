#!/usr/bin/python3

import argparse
from colorama import Fore, Style, init
from prettytable import PrettyTable

from kubernetes import client, config

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Kubernetes namespace operations.")
parser.add_argument("--namespace", type=str, default="kube-system", help="The namespace to operate within")
args = parser.parse_args()
ns = args.namespace

config.load_kube_config()

v1 = client.CoreV1Api()

print(f"Listing pods in {ns} namespace:")

pods = v1.list_namespaced_pod(namespace = ns)

table = PrettyTable()
table.field_names = ["Pod Name", "Status"]
table.align["Pod Name"]="l"

if pods.items:
  for pod in pods.items:
    table.add_row([pod.metadata.name, pod.status.phase])

  print(Fore.RED + str(table) + Style.RESET_ALL)
else:
  print(f'No pods found in the namespace {ns}') 
