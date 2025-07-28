import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton/app/theme/theme.dart';
import 'package:skeleton/app/widgets/generic_card.dart';
import 'package:skeleton/app/helpers/core/http_helper.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  bool _isGridView = false;

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HttpHelper>(
      builder: (context, http, child) {
        return FutureBuilder<Map<String, dynamic>>(
          future: http.fetchMovies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!['success']) {
              return Center(
                child: Text(
                  snapshot.data?['message'] ?? 'Failed to load movies',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                ),
              );
            }

            final movies = snapshot.data!['results'] as List<dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Movies',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          _isGridView
                              ? TablerIcons.layout_list
                              : TablerIcons.layout_grid,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? AppTheme.mutedForeground
                              : AppTheme.darkMutedForeground,
                        ),
                        onPressed: _toggleView,
                        tooltip: _isGridView
                            ? 'Switch to List View'
                            : 'Switch to Grid View',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _isGridView
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.5,
                              ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return _MovieItem(
                              title: movie['title'],
                              overview: movie['overview'],
                              posterPath: movie['poster_path'],
                              releaseDate: movie['release_date'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetail(
                                      title: movie['title'],
                                      overview: movie['overview'],
                                      posterPath: movie['poster_path'],
                                      releaseDate: movie['release_date'],
                                    ),
                                  ),
                                );
                              },
                              isGrid: true,
                            );
                          },
                        )
                      : GenericCard(
                          title: 'Popular Movies',
                          description: 'Browse a collection of popular movies',
                          child: Column(
                            children: movies
                                .asMap()
                                .entries
                                .map(
                                  (entry) => _MovieItem(
                                    title: entry.value['title'],
                                    overview: entry.value['overview'],
                                    posterPath: entry.value['poster_path'],
                                    releaseDate: entry.value['release_date'],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MovieDetail(
                                            title: entry.value['title'],
                                            overview: entry.value['overview'],
                                            posterPath:
                                                entry.value['poster_path'],
                                            releaseDate:
                                                entry.value['release_date'],
                                          ),
                                        ),
                                      );
                                    },
                                    isGrid: false,
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

class _MovieItem extends StatelessWidget {
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final VoidCallback? onTap;
  final bool isGrid;

  const _MovieItem({
    required this.title,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
    this.onTap,
    required this.isGrid,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w342$posterPath',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                              : AppTheme.darkMutedForeground.withValues(
                                  alpha: 0.1,
                                ),
                          child: const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                              : AppTheme.darkMutedForeground.withValues(
                                  alpha: 0.1,
                                ),
                          child: const Center(child: Text('No image')),
                        ),
                      )
                    : Container(
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                            : AppTheme.darkMutedForeground.withValues(
                                alpha: 0.1,
                              ),
                        child: const Center(child: Text('No poster')),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title.length > 25 ? '${title.substring(0, 25)}...' : title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w200$posterPath',
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 60,
                        height: 90,
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                            : AppTheme.darkMutedForeground.withValues(
                                alpha: 0.1,
                              ),
                        child: const Center(child: CircularProgressIndicator.adaptive()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 90,
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                            : AppTheme.darkMutedForeground.withValues(
                                alpha: 0.1,
                              ),
                        child: const Center(child: Text('No image')),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 90,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                          : AppTheme.darkMutedForeground.withValues(alpha: 0.1),
                      child: const Center(child: Text('No poster')),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.length > 50 ? '${title.substring(0, 50)}...' : title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    releaseDate.isNotEmpty
                        ? releaseDate
                        : 'Unknown release date',
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

class MovieDetail extends StatelessWidget {
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;

  const MovieDetail({
    super.key,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Details',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GenericCard(
          title: title,
          description: 'Details of the selected movie',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (posterPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w500$posterPath',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 300,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                          : AppTheme.darkMutedForeground.withValues(alpha: 0.1),
                      child: const Center(child: CircularProgressIndicator.adaptive()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 300,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppTheme.mutedForeground.withValues(alpha: 0.1)
                          : AppTheme.darkMutedForeground.withValues(alpha: 0.1),
                      child: const Center(child: Text('Image not available')),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Release Date: $releaseDate',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Text(
                overview,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.mutedForeground
                      : AppTheme.darkMutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
