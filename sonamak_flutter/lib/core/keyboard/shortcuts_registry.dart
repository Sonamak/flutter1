import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SaveIntent extends Intent { const SaveIntent(); }
class SearchIntent extends Intent { const SearchIntent(); }
class PrintIntent extends Intent { const PrintIntent(); }
class NewIntent extends Intent { const NewIntent(); }

class GlobalShortcuts extends StatelessWidget {
  const GlobalShortcuts({super.key, required this.child, this.onSave, this.onSearch, this.onPrint, this.onNew});
  final Widget child;
  final VoidCallback? onSave;
  final VoidCallback? onSearch;
  final VoidCallback? onPrint;
  final VoidCallback? onNew;
  @override
  Widget build(BuildContext context) {
    final map = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.keyS, control: true): const SaveIntent(),
      const SingleActivator(LogicalKeyboardKey.keyS, meta: true): const SaveIntent(),
      const SingleActivator(LogicalKeyboardKey.keyF, control: true): const SearchIntent(),
      const SingleActivator(LogicalKeyboardKey.keyF, meta: true): const SearchIntent(),
      const SingleActivator(LogicalKeyboardKey.keyP, control: true): const PrintIntent(),
      const SingleActivator(LogicalKeyboardKey.keyP, meta: true): const PrintIntent(),
      const SingleActivator(LogicalKeyboardKey.keyN, control: true): const NewIntent(),
      const SingleActivator(LogicalKeyboardKey.keyN, meta: true): const NewIntent(),
    };
    return Shortcuts(
      shortcuts: map,
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveIntent: CallbackAction<SaveIntent>(onInvoke: (_) { onSave?.call(); return null; }),
          SearchIntent: CallbackAction<SearchIntent>(onInvoke: (_) { onSearch?.call(); return null; }),
          PrintIntent: CallbackAction<PrintIntent>(onInvoke: (_) { onPrint?.call(); return null; }),
          NewIntent: CallbackAction<NewIntent>(onInvoke: (_) { onNew?.call(); return null; }),
        },
        child: FocusTraversalGroup(child: Focus(child: child)),
      ),
    );
  }
}
