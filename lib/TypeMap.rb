include Google::Protobuf::FieldDescriptorProto::Type
include Google::Protobuf::FieldDescriptorProto::Label

TYPE_MAPPING = {
   TYPE_DOUBLE => "Double",
   TYPE_FLOAT => "Float",
   TYPE_INT64 => "Int",
   TYPE_UINT64 => "Int",
   TYPE_INT32 => "Int",
   TYPE_FIXED64 => "Int",
   TYPE_FIXED32 => "Int",
   TYPE_BOOL => "Bool",
   TYPE_STRING => "String",
   TYPE_BYTES => "NSData",
   TYPE_UINT32 => "Int",
   TYPE_SFIXED32 => "Int",
   TYPE_SFIXED64 => "Int",
   TYPE_SINT32 => "Int",
   TYPE_SINT64 => "Int",
 }

 LABEL_MAPPING = {
  LABEL_OPTIONAL => "optional",
  LABEL_REQUIRED => "required",
  LABEL_REPEATED => "repeated",
}
