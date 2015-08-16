## Synopsis

Generate, "by hand", the keys used by [Syncthing](https://syncthing.net/).

Whenever one first uses Syncthing, it will generate the keys for you. Normally,
this is sufficient, but there may be some use cases where one would like to
re-generate the artifacts. (See Motivation, below).

## Code Example

The provided `Makefile` should handle the generation for you. Just running
`make` will generate the key, the intermediate CSR, and finally the
certificate, all in the format (parameters, x509 extensions, etc) expected by
Syncthing.

```
make
```

If there already exists a `key.pem` file in the repo, it will not be
overwritten, and instead will be used in certificate creation. (This is useful,
for example, if you need to create the key on a separate computer with a better
RNG.)

NOTE: whenever the public key (embedded in the public certificate) changes, so
will the device-id of the Syncthing node. To facilitate users to easily know
what this new device-id will be, I have created a special make-target,
"show-id".

```
make show-id
```

If you want to check the device-id of a different file (other than the default
`cert.pem`), you may do so with the CERT key-value pair:

```
make show-id CERT=/path/to/cert.pem
```

Remember to update the `config.xml` file with the new device-id.

## Motivation

This project exists because of the [Android Syncthing app](https://play.google.com/store/apps/details?id=com.nutomic.syncthingandroid&hl=en).
This application, true to Syncthing's nature, generates the keys on first use,
but the RNG on your Android device may not provide enough entropy for a
cryptographically-secure setup.

To generate off-device keys, one can:
1. Launch the application the first time, allowing the app to generate its own keys.
2. Export the configuration
3. Generate the new keys using this repo, off-device
4. Compute the new device-id (derived from new key)
5. Update the exported-configuration to use the new device-id
6. Transfer over to the device the updated configuration and new keys
7. Import the configuration

## Installation

None. Simply clone and perform all operations in-repo.

## Tests

No guarantees, and currently not-tested.

## Contributors

Feel free to submit pull requests with improvements.

## License

IANAL, but to the extent I am capable of licensing this repo, GPLv2.
