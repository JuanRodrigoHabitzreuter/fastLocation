import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddressListItem extends StatelessWidget {
  final AddressModel model;
  final VoidCallback? onTap;
  final Color textColor;
  final Color iconColor;
  final Widget? trailingWidget;

  const AddressListItem({
    super.key,
    required this.model,
    this.onTap,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        model.fullAddress.isEmpty ? model.cep : model.fullAddress,
        style: TextStyle(color: textColor),
      ),
      subtitle: Text(
        '${model.bairro} • ${model.localidade}-${model.estado}', // ajuste do uf
        style: TextStyle(color: textColor),
      ),
      onTap: onTap,
      trailing: trailingWidget ?? Icon(Icons.chevron_right, color: iconColor),
    );
  }
}
