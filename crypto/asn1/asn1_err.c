/*
 * Generated by util/mkerr.pl DO NOT EDIT
 * Copyright 1995-2024 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <openssl/err.h>
#include <openssl/asn1err.h>
#include <crypto/asn1err.h>

#ifndef OPENSSL_NO_ERR

static const ERR_STRING_DATA ASN1_str_reasons[] = {
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ADDING_OBJECT), "adding object"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ASN1_PARSE_ERROR), "asn1 parse error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ASN1_SIG_PARSE_ERROR),
    "asn1 sig parse error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_AUX_ERROR), "aux error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_BAD_OBJECT_HEADER), "bad object header"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_BAD_TEMPLATE), "bad template"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_BMPSTRING_IS_WRONG_LENGTH),
    "bmpstring is wrong length"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_BN_LIB), "bn lib"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_BOOLEAN_IS_WRONG_LENGTH),
    "boolean is wrong length"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_BUFFER_TOO_SMALL), "buffer too small"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_CIPHER_HAS_NO_OBJECT_IDENTIFIER),
    "cipher has no object identifier"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_CONTEXT_NOT_INITIALISED),
    "context not initialised"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_DATA_IS_WRONG), "data is wrong"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_DECODE_ERROR), "decode error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_DEPTH_EXCEEDED), "depth exceeded"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_DIGEST_AND_KEY_TYPE_NOT_SUPPORTED),
    "digest and key type not supported"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ENCODE_ERROR), "encode error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ERROR_GETTING_TIME),
    "error getting time"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ERROR_LOADING_SECTION),
    "error loading section"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ERROR_SETTING_CIPHER_PARAMS),
    "error setting cipher params"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_EXPECTING_AN_INTEGER),
    "expecting an integer"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_EXPECTING_AN_OBJECT),
    "expecting an object"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_EXPLICIT_LENGTH_MISMATCH),
    "explicit length mismatch"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_EXPLICIT_TAG_NOT_CONSTRUCTED),
    "explicit tag not constructed"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_FIELD_MISSING), "field missing"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_FIRST_NUM_TOO_LARGE),
    "first num too large"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_GENERALIZEDTIME_IS_TOO_SHORT),
    "generalizedtime is too short"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_HEADER_TOO_LONG), "header too long"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_BITSTRING_FORMAT),
    "illegal bitstring format"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_BOOLEAN), "illegal boolean"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_CHARACTERS),
    "illegal characters"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_FORMAT), "illegal format"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_HEX), "illegal hex"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_IMPLICIT_TAG),
    "illegal implicit tag"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_INTEGER), "illegal integer"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_NEGATIVE_VALUE),
    "illegal negative value"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_NESTED_TAGGING),
    "illegal nested tagging"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_NULL), "illegal null"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_NULL_VALUE),
    "illegal null value"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_OBJECT), "illegal object"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_OPTIONAL_ANY),
    "illegal optional any"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_OPTIONS_ON_ITEM_TEMPLATE),
    "illegal options on item template"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_PADDING), "illegal padding"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_TAGGED_ANY),
    "illegal tagged any"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_TIME_VALUE),
    "illegal time value"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ILLEGAL_ZERO_CONTENT),
    "illegal zero content"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INTEGER_NOT_ASCII_FORMAT),
    "integer not ascii format"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INTEGER_TOO_LARGE_FOR_LONG),
    "integer too large for long"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_BIT_STRING_BITS_LEFT),
    "invalid bit string bits left"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_BMPSTRING_LENGTH),
    "invalid bmpstring length"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_DIGIT), "invalid digit"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_MIME_TYPE), "invalid mime type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_MODIFIER), "invalid modifier"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_NUMBER), "invalid number"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_OBJECT_ENCODING),
    "invalid object encoding"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_SCRYPT_PARAMETERS),
    "invalid scrypt parameters"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_SEPARATOR), "invalid separator"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_STRING_TABLE_VALUE),
    "invalid string table value"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_UNIVERSALSTRING_LENGTH),
    "invalid universalstring length"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_UTF8STRING),
    "invalid utf8string"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_INVALID_VALUE), "invalid value"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_LENGTH_TOO_LONG), "length too long"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_LIST_ERROR), "list error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MIME_NO_CONTENT_TYPE),
    "mime no content type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MIME_PARSE_ERROR), "mime parse error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MIME_SIG_PARSE_ERROR),
    "mime sig parse error"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MISSING_EOC), "missing eoc"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MISSING_SECOND_NUMBER),
    "missing second number"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MISSING_VALUE), "missing value"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MSTRING_NOT_UNIVERSAL),
    "mstring not universal"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_MSTRING_WRONG_TAG), "mstring wrong tag"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NESTED_ASN1_STRING),
    "nested asn1 string"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NESTED_TOO_DEEP), "nested too deep"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NON_HEX_CHARACTERS),
    "non hex characters"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NOT_ASCII_FORMAT), "not ascii format"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NOT_ENOUGH_DATA), "not enough data"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NO_CONTENT_TYPE), "no content type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NO_MATCHING_CHOICE_TYPE),
    "no matching choice type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NO_MULTIPART_BODY_FAILURE),
    "no multipart body failure"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NO_MULTIPART_BOUNDARY),
    "no multipart boundary"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NO_SIG_CONTENT_TYPE),
    "no sig content type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_NULL_IS_WRONG_LENGTH),
    "null is wrong length"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_OBJECT_NOT_ASCII_FORMAT),
    "object not ascii format"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_ODD_NUMBER_OF_CHARS),
    "odd number of chars"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_SECOND_NUMBER_TOO_LARGE),
    "second number too large"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_SEQUENCE_LENGTH_MISMATCH),
    "sequence length mismatch"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_SEQUENCE_NOT_CONSTRUCTED),
    "sequence not constructed"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_SEQUENCE_OR_SET_NEEDS_CONFIG),
    "sequence or set needs config"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_SHORT_LINE), "short line"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_SIG_INVALID_MIME_TYPE),
    "sig invalid mime type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_STREAMING_NOT_SUPPORTED),
    "streaming not supported"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_STRING_TOO_LONG), "string too long"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_STRING_TOO_SHORT), "string too short"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_THE_ASN1_OBJECT_IDENTIFIER_IS_NOT_KNOWN_FOR_THIS_MD),
    "the asn1 object identifier is not known for this md"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_TIME_NOT_ASCII_FORMAT),
    "time not ascii format"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_TOO_LARGE), "too large"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_TOO_LONG), "too long"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_TOO_SMALL), "too small"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_TYPE_NOT_CONSTRUCTED),
    "type not constructed"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_TYPE_NOT_PRIMITIVE),
    "type not primitive"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNEXPECTED_EOC), "unexpected eoc"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNIVERSALSTRING_IS_WRONG_LENGTH),
    "universalstring is wrong length"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNKNOWN_DIGEST), "unknown digest"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNKNOWN_FORMAT), "unknown format"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNKNOWN_MESSAGE_DIGEST_ALGORITHM),
    "unknown message digest algorithm"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNKNOWN_OBJECT_TYPE),
    "unknown object type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNKNOWN_PUBLIC_KEY_TYPE),
    "unknown public key type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNKNOWN_SIGNATURE_ALGORITHM),
    "unknown signature algorithm"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNKNOWN_TAG), "unknown tag"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNSUPPORTED_ANY_DEFINED_BY_TYPE),
    "unsupported any defined by type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNSUPPORTED_CIPHER),
    "unsupported cipher"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNSUPPORTED_PUBLIC_KEY_TYPE),
    "unsupported public key type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UNSUPPORTED_TYPE), "unsupported type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_UTCTIME_IS_TOO_SHORT),
    "utctime is too short"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_WRONG_INTEGER_TYPE),
    "wrong integer type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_WRONG_PUBLIC_KEY_TYPE),
    "wrong public key type"},
    {ERR_PACK(ERR_LIB_ASN1, 0, ASN1_R_WRONG_TAG), "wrong tag"},
    {0, NULL}
};

#endif

int ossl_err_load_ASN1_strings(void)
{
#ifndef OPENSSL_NO_ERR
    if (ERR_reason_error_string(ASN1_str_reasons[0].error) == NULL)
        ERR_load_strings_const(ASN1_str_reasons);
#endif
    return 1;
}
