import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton/app/theme/theme.dart';
import 'package:skeleton/app/widgets/generic_card.dart';
import 'package:skeleton/app/helpers/core/http_helper.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Quotes extends StatelessWidget {
  const Quotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HttpHelper>(
      builder: (context, http, child) {
        return FutureBuilder<Map<String, dynamic>>(
          future: http.fetchQuotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!['success']) {
              return Center(
                child: Text(
                  snapshot.data?['message'] ?? 'Failed to load quotes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                ),
              );
            }

            final quotes = snapshot.data!['results'] as List<dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quotes',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GenericCard(
                    title: 'Inspirational Quotes',
                    description: 'Browse a collection of quotes',
                    child: Column(
                      children: quotes
                          .asMap()
                          .entries
                          .map(
                            (entry) => _QuoteItem(
                              quote: entry.value['q'],
                              author: entry.value['a'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuoteDetail(
                                      quote: entry.value['q'],
                                      author: entry.value['a'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuoteItem extends StatelessWidget {
  final String quote;
  final String author;
  final VoidCallback? onTap;

  const _QuoteItem({required this.quote, required this.author, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppTheme.border
                  : AppTheme.darkBorder,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              TablerIcons.quote,
              size: 20,
              color: Theme.of(context).brightness == Brightness.light
                  ? AppTheme.mutedForeground
                  : AppTheme.darkMutedForeground,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${quote.length > 50 ? '${quote.substring(0, 50)}...' : quote}"',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    author,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppTheme.mutedForeground
                          : AppTheme.darkMutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Theme.of(context).brightness == Brightness.light
                  ? AppTheme.mutedForeground
                  : AppTheme.darkMutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteDetail extends StatelessWidget {
  final String quote;
  final String author;

  const QuoteDetail({super.key, required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quote Details',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GenericCard(
          title: 'Quote',
          description: 'Quote Details.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"$quote"',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.mutedForeground
                      : AppTheme.darkMutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '— $author',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
