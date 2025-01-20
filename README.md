# ![veld chain](https://raw.githubusercontent.com/veldhub/.github/refs/heads/main/images/symbol_V_letter.png) veld_code__xml_xslt_transformer

This repo contains [code velds](https://zenodo.org/records/13322913) encapsulating generic xml / 
xslt transformation. 

## requirements

- git
- docker compose (note: older docker compose versions require running `docker-compose` instead of 
  `docker compose`)

## how to use

A code veld may be integrated into a chain veld, or used directly by adapting the configuration 
within its yaml file and using the template folders provided in this repo. Open the respective veld 
yaml file for more information.

Run a veld with:
```
docker compose -f <VELD_NAME>.yaml up
```

## contained code velds

**[./veld.yaml](./veld.yaml)** 

The transformation veld

```
docker compose -f veld.yaml up
```

