import 'package:flutter/material.dart';

class CmsTopBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const CmsTopBar({
    Key? key,
    required this.title,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0.0, 0.75),
          ),
        ],
        color: Theme.of(context).colorScheme.surface,
      ),
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 16),
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: action,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
