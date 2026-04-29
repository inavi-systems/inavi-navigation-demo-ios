import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'iNavi Navigation SDK for iOS',
  description: 'iNavi iOS Navigation SDK Developer Guide',
  base: '/inavi-navigation-ios-developer-guide/',
  srcExclude: [
    'plans/**',
    'ios-vitepress-pages-plan.md'
  ],
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' }
    ],
    outline: {
      level: 2
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/inavi-systems/inavi-navigation-demo-ios' }
    ]
  }
})
