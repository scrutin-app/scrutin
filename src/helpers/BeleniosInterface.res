@module("./belenios/src/web/clients/jslib/belenios_api.js")
@val external derive: (string, string) => string = "derive"

@module("./belenios/src/web/clients/jslib/belenios_api.js")
@val external makeCredentials: (string, int) => (array<string>, array<string>) = "makeCredentials"

@module("./belenios/src/web/clients/jslib/belenios_api.js")
@val external genTrustee: () => (string, string) = "genTrustee"

@module("./belenios/src/web/clients/jslib/belenios_api.js")
@val external makeElection: (string, string, array<string>, string) => string = "makeElection"

@module("./belenios/src/web/clients/jslib/belenios_api.js")
@val external encryptBallot: (string, string, array<array<int>>, string) => string = "encryptBallot"

@module("./belenios/src/web/clients/jslib/belenios_api.js")
@val external decrypt: (string, array<string>, string, array<string>, string) => (string, string) = "decrypt"

@module("./belenios/src/web/clients/jslib/belenios_api.js")
@val external result: (string, array<string>, string, array<string>, string, string) => string = "result"
