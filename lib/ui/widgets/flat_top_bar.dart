import 'package:flutter/material.dart';
import 'package:flat/constants.dart';

class FlatTopBar extends StatelessWidget {
  final String? title;
  final List<Widget> actions;

  const FlatTopBar({
    Key? key,
    this.title,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < mobileViewMaxWidth;

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
      height: 56 + MediaQuery.of(context).padding.top,
      child: Row(
        children: [
          const SizedBox(width: 16),
          if (isMobile) ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: 16),
          ],
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: action,
            ),
          ),
          if (title != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
