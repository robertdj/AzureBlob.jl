AzureBlob
=========

The *AzureBlob* package provides functionality for downloading and uploading content between Julia and [Azure Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs).

The interaction is through the REST interface provided by the blob storage.
Downloading files uses HTTP GET and uploading uses HTTP PUT through the [HTTP package](https://github.com/JuliaWeb/HTTP.jl).

Authorization happens with the `SharedKey` scheme as described in [official docs](https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key).
This uses a signature that needs the storage account, storage key and resource group of the blob storage.

The package is a work in progress and at the time of writing quite unpolished.


## Unit tests

The main functions of the *AzureBlob* package (`get_blob` and `put_blob`) are *not* tested in the unit tests since I do not have a publicly accessible blob storage.


## Acknowledgement

The *AzureBlob* package is inspired by similar functionality in the [AzureSMR](https://github.com/Microsoft/AzureSMR)/[AzureStor](https://github.com/cloudyr/AzureStor) packages for R.

