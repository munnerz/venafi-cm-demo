# venafi-cm-demo

This repository contains a script that can be used to quickly provision
a demo environment to show cert-manager with Venafi integration.

It is compatible with Linux and OSX, and only requires Docker in order
to run.

Any additional required dependencies will be pulled automatically.

## Usage

To get started, simply run:

```bash
$ git clone https://github.com/munnerz/venafi-cm-demo.git
$ cd venafi-cm-demo/
$ ./setup-demo.sh

...

All components have been deployed!

Please run the following command to make 'kubectl' work:

	export KUBECONFIG=/Users/james/.kube/kind-config-venafi
```

It may take up to 2 minutes to provision the environment.

## Issues

If you encounter any issues whilst running this script, please
open an issue on this repository.

