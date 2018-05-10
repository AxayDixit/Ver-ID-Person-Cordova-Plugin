<!-- Generated by documentation.js. Update this documentation by updating the source code. -->

### Table of Contents

-   [compareFaceTemplates](#comparefacetemplates)
-   [base64ToFloat32Array](#base64tofloat32array)
-   [float32ArrayToBase64](#float32arraytobase64)

## compareFaceTemplates

Compare two face templates and return a similarity score

**Parameters**

-   `t1` **([string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String) \| [Array](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Array)&lt;[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)>)** Face template (array of floating point integer values or base 64 encoded string)
-   `t2` **([string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String) \| [Array](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Array)&lt;[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)>)** Face template (array of floating point integer values or base 64 encoded string)
-   `norm1` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Template 1 norm (optional) (optional, default `1`)
-   `norm2` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Template 2 norm (optional) (optional, default `1`)

Returns **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Similarity score between 0.0 and 1.0

## base64ToFloat32Array

Decode a base 64 encoded string to an array of 32-bit floating point integer values

**Parameters**

-   `base64` **[string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String)** Base 64 string

Returns **any** Array of floating point integers

## float32ArrayToBase64

Encode an array of 32-bit floating point integer values to a base 64 string

**Parameters**

-   `floatArray` **[Array](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Array)&lt;[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)>** Array of floating point integers

Returns **any** Array converted to string