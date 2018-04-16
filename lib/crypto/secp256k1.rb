require 'base64'
require 'secp256k1'

module Crypto
  module Secp256k1

    # Elliptic curve parameters
    P  = 2**256 - 2**32 - 977
    N  = 115792089237316195423570985008687907852837564279074904382605163141518161494337
    A  = 0
    B  = 7
    Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240
    Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424
    G  = [Gx, Gy].freeze

    class InvalidPrivateKey < StandardError; end

    class <<self # extensions
      def recover_pubkey(msg, vrs, compressed: false)
        pk = ::Secp256k1::PublicKey.new(flags: ::Secp256k1::ALL_FLAGS)
        sig = vrs[1] + vrs[2]
        recsig = pk.ecdsa_recoverable_deserialize(sig, vrs[0])
        pk.public_key = pk.ecdsa_recover msg, recsig, raw: true
        pk.serialize compressed: compressed
      end
    end
  end
end