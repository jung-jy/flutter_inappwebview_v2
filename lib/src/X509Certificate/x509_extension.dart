import 'x509_certificate.dart';
import 'asn1_object.dart';
import 'oid.dart';

class X509Extension {
  ASN1Object? block;

  X509Extension({required this.block});

  String? get oid => block?.subAtIndex(0)?.value;

  String? get name => OID.fromValue(oid)?.name();

  bool get isCritical {
    if ((block?.sub?.length ?? 0) > 2) {
      return block?.subAtIndex(1)?.value ?? false;
    }
    return false;
  }

  dynamic get value {
    var sub = block?.sub;
    if (sub != null && sub.length > 0) {
      ASN1Object? valueBlock;
      try {
        valueBlock = sub.last;
      } catch (e) {}
      if (valueBlock != null) {
        return firstLeafValue(block: valueBlock);
      }
    }
    return null;
  }

  ASN1Object? get valueAsBlock {
    var sub = block?.sub;
    if (sub != null && sub.length > 0) {
      ASN1Object? valueBlock;
      try {
        valueBlock = sub.last;
      } catch (e) {}
      return valueBlock;
    }
    return null;
  }

  List<String> get valueAsStrings {
    var result = <String>[];
    var sub = <ASN1Object>[];
    try {
      sub = block?.sub?.last.sub?.last.sub ?? <ASN1Object>[];
    } catch (e) {}

    for (var item in sub) {
      var name = item.value;
      if (name != null) {
        result.add(name);
      }
    }
    return result;
  }
}
