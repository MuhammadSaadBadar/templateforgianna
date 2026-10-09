import '../core/cloudinary.dart';

// ============================================================================
//  THIS IS THE ONLY FILE YOU EDIT FOR A NEW EDITOR.
//  Replace the values in `siteConfig` at the bottom. Video links can be plain
//  Cloudinary "video/upload" URLs; previews and posters are generated for you.
// ============================================================================

class Editor {
  const Editor({
    required this.name,
    required this.initials,
    required this.headlineTop,
    required this.headlineAccent,
    required this.subheadline,
    required this.email,
  });
  final String name, initials, headlineTop, headlineAccent, subheadline, email;
}

class Cta {
  const Cta({required this.label, required this.url, required this.secondaryLabel});
  final String label, url, secondaryLabel;
}

class Creator {
  const Creator(this.name, this.subs, {this.url = ''});
  final String name, subs, url;
}

class Project {
  const Project({
    required this.title,
    required this.client,
    required this.role,
    required this.videoUrl,
    required this.brief,
    required this.resultValue,
    required this.resultLabel,
    required this.tags,
    this.duration = '',
    this.vertical = false,
    this.previewUrl,
    this.posterUrl,
  });

  final String title, client, role, videoUrl, brief, resultValue, resultLabel, duration;
  final List<String> tags;
  final bool vertical;
  final String? previewUrl, posterUrl;

  /// Short looping preview. Auto-generated from a Cloudinary link unless overridden.
  String get preview => previewUrl ?? Cloudinary.preview(videoUrl);
  String get poster => posterUrl ?? Cloudinary.poster(videoUrl);
  String get full => Cloudinary.full(videoUrl);
}

class Stat {
  const Stat(this.value, this.suffix, this.label);
  final int value;
  final String suffix, label;
}

class Service {
  const Service(this.name, this.description, this.tags);
  final String name, description;
  final List<String> tags;
}

class Step {
  const Step(this.title, this.text, this.time);
  final String title, text, time;
}

class Testimonial {
  const Testimonial({required this.quote, required this.name, required this.channel, required this.audience, required this.result});
  final String quote, name, channel, audience, result;
}

class Tier {
  const Tier({required this.name, required this.price, required this.unit, required this.features, this.popular = false});
  final String name, price, unit;
  final List<String> features;
  final bool popular;
}

class Faq {
  const Faq(this.q, this.a);
  final String q, a;
}

class Social {
  const Social(this.label, this.url);
  final String label, url;
}

class SiteConfig {
  const SiteConfig({
    required this.editor,
    required this.cta,
    required this.proofText,
    required this.ratingText,
    required this.trustHeading,
    required this.creators,
    required this.workIntro,
    required this.projects,
    required this.stats,
    required this.typical,
    required this.mine,
    required this.services,
    required this.steps,
    required this.testimonials,
    required this.tiers,
    required this.faqs,
    required this.finalHeading,
    required this.finalText,
    required this.socials,
    this.showPackages = true,
  });

  final Editor editor;
  final Cta cta;
  final String proofText, ratingText, trustHeading, workIntro, finalHeading, finalText;
  final List<Creator> creators;
  final List<Project> projects;
  final List<Stat> stats;
  final List<String> typical, mine;
  final List<Service> services;
  final List<Step> steps;
  final List<Testimonial> testimonials;
  final bool showPackages;
  final List<Tier> tiers;
  final List<Faq> faqs;
  final List<Social> socials;
}

// ---------------------------------------------------------------------------
//  SAMPLE DATA. Replace the video URLs with your own Cloudinary links, e.g.
//  https://res.cloudinary.com/YOUR_CLOUD_NAME/video/upload/v123/my_edit.mp4
//  (the "demo" cloud links below are Cloudinary sample clips for testing.)
// ---------------------------------------------------------------------------
const siteConfig = SiteConfig(
  editor: Editor(
    name: 'Gianna Piers',
    initials: 'GP',
    headlineTop: 'Turning raw footage into',
    headlineAccent: 'videos people finish.',
    subheadline:
        'Long-form YouTube editing for tech and finance creators. Sharper pacing, cleaner storytelling, higher retention.',
    email: 'hello@example.com',
  ),
  cta: Cta(label: 'Book a call', url: 'https://cal.com/your-link', secondaryLabel: 'View showreel'),
  proofText: 'Trusted by 60+ creators',
  ratingText: '★★★★★ 5.0 client rating',
  trustHeading: 'Edited for channels with 12M+ subscribers combined',
  creators: [
    Creator('TechForge', '2.4M subs'),
    Creator('Ledger Lab', '1.1M subs'),
    Creator('Nina Codes', '680K subs'),
    Creator('Daily Bytes', '420K subs'),
    Creator('Vault Talk', '310K subs'),
    Creator('PixelPath', '250K subs'),
    Creator('Mira Money', '190K subs'),
    Creator('Dev Diaries', '120K subs'),
  ],
  workIntro: 'Hover a project to preview it. Click to watch the full cut and see what it did for the channel.',
  projects: [
    Project(
      title: 'I Tried Every AI Coding Tool',
      client: 'TechForge',
      role: 'Full edit, motion graphics',
      videoUrl: 'https://res.cloudinary.com/demo/video/upload/dog.mp4',
      brief:
          'A 22-minute comparison that kept losing viewers around the 6-minute mark. I rebuilt the structure, tightened the cold open and added on-screen scoring.',
      resultValue: '+41%',
      resultLabel: 'avg. view duration',
      tags: ['Long-form', 'Motion graphics', 'Sound design'],
      duration: '22:14',
    ),
    Project(
      title: 'The Real Cost of Investing at 25',
      client: 'Ledger Lab',
      role: 'Edit, captions, b-roll',
      videoUrl: 'https://res.cloudinary.com/demo/video/upload/elephants.mp4',
      brief: 'Data-heavy explainer turned into a story with animated charts and a consistent visual language.',
      resultValue: '1.8M',
      resultLabel: 'views in 30 days',
      tags: ['Explainer', 'Data viz'],
      duration: '14:02',
    ),
    Project(
      title: 'Ship It Friday: Episode 12',
      client: 'Nina Codes',
      role: 'Edit and thumbnail brief',
      videoUrl: 'https://res.cloudinary.com/demo/video/upload/sea-turtle.mp4',
      brief: 'Weekly series cut down from raw screen recordings in under 48 hours, with a repeatable template.',
      resultValue: '3x',
      resultLabel: 'faster turnaround',
      tags: ['Series', 'Screen recording'],
      duration: '11:40',
    ),
    Project(
      title: '60 Seconds on Bitcoin ETFs',
      client: 'Daily Bytes',
      role: 'Short-form edit',
      videoUrl: 'https://res.cloudinary.com/demo/video/upload/dog.mp4',
      brief: 'Vertical cut with kinetic captions and a hook in the first 1.5 seconds.',
      resultValue: '920K',
      resultLabel: 'views on one Short',
      tags: ['Shorts', 'Captions'],
      duration: '0:58',
      vertical: true,
    ),
  ],
  stats: [
    Stat(12, 'M+', 'views across edited videos'),
    Stat(41, '%', 'average lift in view duration'),
    Stat(60, '+', 'creators edited for'),
  ],
  typical: [
    'Slow replies and missed deadlines',
    'One-size cuts that ignore your audience',
    'Retention drops nobody explains',
    'Revisions that turn into arguments',
  ],
  mine: [
    'First cut in 48 hours, every time',
    'Pacing built around your retention graph',
    'A short note on why each edit was made',
    'Two revision rounds, handled fast',
  ],
  services: [
    Service('Long-form YouTube editing', 'Full edits with story structure, pacing, sound and motion graphics.',
        ['Retention', 'Sound design', 'Captions']),
    Service('Shorts and Reels', 'Vertical cuts pulled from your long videos.', ['Hooks', 'Kinetic text']),
    Service('Motion graphics', 'Lower thirds, charts and explainers that match your brand.',
        ['After Effects', 'Data viz']),
    Service('Ongoing editing partner', 'A fixed monthly slot so your upload schedule never slips.',
        ['Monthly', 'Priority']),
  ],
  steps: [
    Step('Brief and references', 'You send raw footage and a few videos you like. I ask what the video needs to do.', 'Day 0'),
    Step('First cut', 'Story, pacing and rough sound, delivered as a review link.', '48 hours'),
    Step('Revisions', 'Timestamped notes from you, changes from me.', '24 hours per round'),
    Step('Final delivery', 'Export, captions and files, ready to upload.', 'Same day'),
  ],
  testimonials: [
    Testimonial(
        quote: 'He understood the video in one call and the first cut needed almost no changes.',
        name: 'Alex R.', channel: 'TechForge', audience: '2.4M subs', result: '+41% view duration'),
    Testimonial(
        quote: 'Retention improved on every upload since we started working together.',
        name: 'Priya S.', channel: 'Ledger Lab', audience: '1.1M subs', result: '1.8M views in 30 days'),
    Testimonial(
        quote: 'Fast, clear and never needed chasing. Our schedule finally runs on time.',
        name: 'Marcus L.', channel: 'Nina Codes', audience: '680K subs', result: '3x faster turnaround'),
  ],
  showPackages: true,
  tiers: [
    Tier(name: 'Single video', price: '\$300', unit: '/video',
        features: ['Up to 15 min edit', 'Motion titles and captions', '2 revision rounds']),
    Tier(name: 'Monthly', price: '\$1,100', unit: '/month', popular: true,
        features: ['4 videos per month', 'Priority turnaround', 'Shorts cutdowns included', 'Retention notes']),
    Tier(name: 'Custom', price: "Let's talk", unit: '',
        features: ['Series and campaigns', 'Team collaboration', 'Custom scope and volume']),
  ],
  faqs: [
    Faq('What do I need to send?', 'Raw footage, a short brief and any brand assets. Shared drive links work fine.'),
    Faq('How fast is delivery?', 'First cuts arrive within 48 hours for standard videos. Rush options exist for a small fee.'),
    Faq('How many revisions do I get?', 'Two rounds are included. Additional rounds are billed at a simple hourly rate.'),
    Faq('Can you match my existing style?', 'Yes. Send references or past videos and I will match your pacing, fonts and graphics.'),
    Faq('Which software do you use?', 'Premiere Pro, After Effects and DaVinci Resolve. I deliver in any format you need.'),
  ],
  finalHeading: 'Ready for edits that keep viewers watching?',
  finalText: 'Tell me about your channel on a 15-minute call. You will get a plan for your next upload.',
  socials: [
    Social('YouTube', '#'),
    Social('X', '#'),
    Social('Instagram', '#'),
    Social('Email', 'mailto:hello@example.com'),
  ],
);
