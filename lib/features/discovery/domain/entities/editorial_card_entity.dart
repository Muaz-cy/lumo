/// Lumo — Discovery Editorial Entity
/// An editorial card is a story, not a product listing.
/// It has a mood, a headline, and a call to action.
enum EditorialCardSize { hero, wide, square }

final class EditorialCardEntity {
  const EditorialCardEntity({
    required this.id,
    required this.headline,
    required this.subheadline,
    required this.imageUrl,
    required this.size,
    this.tag,
    this.actionLabel,
    this.actionRoute,
  });

  final String id;
  final String headline;
  final String subheadline;
  final String imageUrl;
  final EditorialCardSize size;

  /// Short category tag shown above the headline (e.g. "New Arrivals").
  final String? tag;
  final String? actionLabel;
  final String? actionRoute;
}
