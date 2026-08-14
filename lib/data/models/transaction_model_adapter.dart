import 'package:hive/hive.dart';

import 'transaction_model.dart';

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    return TransactionModel(
      title: reader.readString(),
      amount: reader.readDouble(),
      type: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(
        reader.readInt(),
      ),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.type);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
  }
}