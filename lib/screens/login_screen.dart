import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../widgets/login_form.dart';
import '../widgets/feature_card.dart';
import '../widgets/particle_background.dart';
import '../widgets/platform_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PlatformContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              // 左侧内容区域
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isDarkMode
                              ? [
                                const Color(0xFF1E293B),
                                const Color(0xFF0F172A),
                              ]
                              : [
                                const Color(0xFF4568DC),
                                const Color(0xFF3023AE),
                              ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 粒子背景
                      const ParticleBackground(),

                      // 主要内容
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 80),

                            Text(
                              '智能投放AI助手',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '集成Google AdSense、AFS、CSE等全平台管理\nAI驱动的广告投放决策引擎，释放数字营销潜能',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.75),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 50),
                            _buildFeatureSection(isDarkMode),
                            const SizedBox(height: 160),

                            // 客户统计区域 - 移到底部
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildClientSection(),
                            ),
                            // 信任徽章
                            Row(
                              children: [
                                _buildTrustBadge(
                                  Icons.check_circle_outline,
                                  '高效',
                                ),
                                const SizedBox(width: 16),
                                _buildTrustBadge(Icons.shield_outlined, '安全'),
                                const SizedBox(width: 16),
                                _buildTrustBadge(Icons.star_outline, '智能'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 右侧登录区域
              Expanded(
                flex: 2,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * 0.25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 欢迎文本
                        Text(
                          '欢迎使用 李茶',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color:
                                isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '提供高效、智能的广告投放解决方案',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDarkMode
                                    ? Colors.white.withOpacity(0.5)
                                    : const Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // 登录表单
                        MouseRegion(opaque: false, child: const LoginForm()),
                        const SizedBox(height: 40),

                        // 底部法律文本
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : const Color(0xFF777777),
                            ),
                            children: [
                              const TextSpan(text: '登录即表示同意 '),
                              TextSpan(
                                text: '用户协议',
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.blue.shade300
                                          : const Color(0xFF4568DC),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(text: ' 和 '),
                              TextSpan(
                                text: '隐私政策',
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.blue.shade300
                                          : const Color(0xFF4568DC),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 版本信息
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            'v1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isDarkMode
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 功能卡片区域 - 放大卡片
  Widget _buildFeatureSection(bool isDarkMode) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                icon: 'lib/assets/images/jj.png',
                title: '智能竞价',
                description: '24/7实时调整，提高ROI',
                statistic: '31%',
                isDarkMode: isDarkMode,
                height: 90, // 增加卡片高度
              ),
            ),
            const SizedBox(width: 20), // 增加间距
            Expanded(
              child: FeatureCard(
                icon: 'lib/assets/images/dc.png',
                title: '数据洞察',
                description: '多维分析，转化率提升',
                statistic: '38%',
                isDarkMode: isDarkMode,
                iconScale: 0.9,
                height: 90, // 增加卡片高度
              ),
            ),
          ],
        ),
        const SizedBox(height: 20), // 增加间距
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                icon: 'lib/assets/images/wa.png',
                title: 'AI文案',
                description: '点击率比传统高',
                statistic: '53%',
                isDarkMode: isDarkMode,
                height: 90, // 增加卡片高度
              ),
            ),
            const SizedBox(width: 20), // 增加间距
            Expanded(
              child: FeatureCard(
                icon: 'lib/assets/images/yj.png',
                title: '智能预警',
                description: '异常监控，响应时间快',
                statistic: '85%',
                isDarkMode: isDarkMode,
                height: 90, // 增加卡片高度
              ),
            ),
          ],
        ),
        const SizedBox(height: 20), // 增加间距
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                icon: 'lib/assets/images/bs.png',
                title: '快速部署',
                description: '投放效率提升',
                statistic: '65%',
                isDarkMode: isDarkMode,
                height: 90, // 增加卡片高度
              ),
            ),
            const SizedBox(width: 20), // 增加间距
            Expanded(
              child: FeatureCard(
                icon: 'lib/assets/images/pt.png',
                title: '多平台',
                description: '一键管理多平台',
                statistic: '100+',
                isDarkMode: isDarkMode,
                iconScale: 1.1,
                height: 90, // 增加卡片高度
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 分隔区域 - 去掉背景色
  Widget _buildDividerSection() {
    return SizedBox(
      height: 60,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHighlight('科技赋能'),
            _buildDot(),
            _buildHighlight('智能决策'),
            _buildDot(),
            _buildHighlight('效果至上'),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlight(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20, // 增大字号
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
    );
  }

  // 客户统计区域
  Widget _buildClientSection() {
    return Row(
      children: [
        _buildStatItem(Icons.people, '12,800+', '营销团队'),
        const SizedBox(width: 60), // 增加间距
        _buildStatItem(Icons.public, '36+', '国家地区'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String number, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.85), size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5CFFB1),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
