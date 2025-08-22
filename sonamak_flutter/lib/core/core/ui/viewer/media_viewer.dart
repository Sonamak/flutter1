
import 'package:flutter/material.dart';

/// Viewer with a simple toolbar (zoom in/out, open externally) and basic semantics.
class MediaViewer extends StatefulWidget {
  const MediaViewer(this.url, {super.key, this.isPdf = false, this.onOpenExternal});
  final String url;
  final bool isPdf;
  final VoidCallback? onOpenExternal;

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Toolbar
        Semantics(
          label: 'Viewer toolbar',
          child: Row(
            children: [
              IconButton(
                tooltip: 'Zoom out',
                onPressed: _scale > 0.5 ? () => setState(() => _scale = (_scale - 0.1).clamp(0.5, 4.0)) : null,
                icon: const Icon(Icons.zoom_out),
              ),
              Text('${(_scale * 100).round()}%'),
              IconButton(
                tooltip: 'Zoom in',
                onPressed: _scale < 4.0 ? () => setState(() => _scale = (_scale + 0.1).clamp(0.5, 4.0)) : null,
                icon: const Icon(Icons.zoom_in),
              ),
              const Spacer(),
              Tooltip(message: 'Open externally', child: IconButton(
                onPressed: widget.onOpenExternal,
                icon: const Icon(Icons.open_in_new),
              )),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: widget.isPdf
              ? _buildPdfPlaceholder(theme)
              : _buildImage(),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        scaleEnabled: true,
        child: Transform.scale(
          scale: _scale,
          child: Image.network(widget.url, errorBuilder: (_, __, ___) {
            return const Center(child: Text('Failed to load image'));
          }),
        ),
      ),
    );
  }

  Widget _buildPdfPlaceholder(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.picture_as_pdf, size: 48),
          const SizedBox(height: 8),
          Text('PDF cannot be rendered inline in this build.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Use the "Open externally" button to view or download.', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
