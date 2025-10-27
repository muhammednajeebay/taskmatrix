import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrgSettingsPage extends StatefulWidget {
  const OrgSettingsPage({super.key});

  @override
  State<OrgSettingsPage> createState() => _OrgSettingsPageState();
}

class _OrgSettingsPageState extends State<OrgSettingsPage> {
  final _nameController = TextEditingController();
  String? _domainKey;
  String? _logoUrl;
  String? _orgId;
  String? _role;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrg();
  }

  Future<void> _loadOrg() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) GoRouter.of(context).go('/login');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final u = await supabase
          .from('users')
          .select('org_id, role, name')
          .eq('id', user.id)
          .maybeSingle();
      if (u == null || u['org_id'] == null) {
        setState(() {
          _loading = false;
          _error = 'No organization linked to your account.';
        });
        return;
      }
      _orgId = u['org_id'] as String?;
      _role = u['role'] as String?;

      final orgIdLocal = _orgId; // capture for promotion
      if (orgIdLocal == null) {
        setState(() {
          _loading = false;
          _error = 'Organization ID missing.';
        });
        return;
      }
      final org = await supabase
          .from('organizations')
          .select('id, name, domain_key, logo_url')
          .eq('id', orgIdLocal)
          .maybeSingle();

      if (org == null) {
        setState(() {
          _loading = false;
          _error = 'Organization not found.';
        });
        return;
      }

      _nameController.text = (org['name'] as String?) ?? '';
      _domainKey = org['domain_key'] as String?;
      _logoUrl = org['logo_url'] as String?;

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _save() async {
    final orgIdLocal = _orgId; // capture for promotion
    if (orgIdLocal == null) return;
    final supabase = Supabase.instance.client;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await supabase
          .from('organizations')
          .update({'name': _nameController.text.trim()})
          .eq('id', orgIdLocal);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Organization updated')));
      }
      await _loadOrg();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = (_role == 'admin');
    return Scaffold(
      appBar: AppBar(title: const Text('Organization Settings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Organization Info',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Organization Name',
                              prefixIcon: Icon(Icons.business),
                            ),
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: TextEditingController(text: _domainKey ?? ''),
                            decoration: const InputDecoration(
                              labelText: 'Domain Key',
                              prefixIcon: Icon(Icons.domain),
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: TextEditingController(text: _logoUrl ?? ''),
                            decoration: const InputDecoration(
                              labelText: 'Logo URL',
                              prefixIcon: Icon(Icons.image),
                              helperText: 'Logo upload coming soon',
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 16),
                          if (!canEdit)
                            const Text(
                              'Only administrators can edit organization details.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: canEdit ? _save : null,
                                  icon: const Icon(Icons.save),
                                  label: const Text('Save Changes'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _loadOrg(),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reload'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
