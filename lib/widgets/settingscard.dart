import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final Icon leadingIcon;
  final Widget trailingWidget;
  final String thistitle;
  final String thissubtitle;
  final bool isImportant;
  const SettingsCard({
    super.key,
    required this.trailingWidget,
    required this.leadingIcon,
    required this.thistitle,
    required this.thissubtitle,
    required this.isImportant,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
        child: Card.filled(
          color: isImportant
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                    leading: leadingIcon,
                    title: Text(thistitle),
                    subtitle: Text(thissubtitle),
                    trailing: trailingWidget),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
