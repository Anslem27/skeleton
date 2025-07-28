import 'package:hive_ce/hive.dart';

import '../app/helpers/models/log.dart';


@GenerateAdapters([AdapterSpec<LogEntry>()])


part 'hive_adapters.g.dart';

