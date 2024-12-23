import { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

import { themes as prismThemes } from "prism-react-renderer";

require('dotenv').config({path: ".env.local"});

const config: Config = {
	title: "Cours EPSI B3 Data/IA",
	tagline: "(selon les notes d'Emilia)",
	favicon: "img/croqui.ico",

	// Set the production url of your site here
	url: "https://bahailime.github.io/",
	// Set the /<baseUrl>/ pathname under which your site is served
	// For GitHub pages deployment, it is often '/<projectName>/'
	baseUrl: "/coursEPSI/",

	// GitHub pages deployment config.
	// If you aren't using GitHub pages, you don't need these.
	organizationName: "bahEmilia", // Usually your GitHub org/user name.
	projectName: "coursEPSI", // Usually your repo name.
	trailingSlash: false,

	onBrokenLinks: "throw",
	onBrokenMarkdownLinks: "warn",

	// Even if you don't use internationalization, you can use this field to set
	// useful metadata like html lang. For example, if your site is Chinese, you
	// may want to replace "en" with "zh-Hans".
	i18n: {
		defaultLocale: "fr",
		locales: ["fr"],
	},

	// Enable Mermaid for diagrams
	markdown: {
		mermaid: true,
	},
	themes: ["@docusaurus/theme-mermaid"],

	presets: [
		[
			"classic",
			{
				docs: {
					sidebarPath: "./sidebars.ts",
					// routeBasePath: "/",
					// Please change this to your repo.
					// Remove this to remove the "edit this page" links.
					editUrl: "https://github.com/bahAilime/coursEPSI/blob/main",
				},
				// blog: false,
				blog: {
					showReadingTime: true,
					// Please change this to your repo.
					// Remove this to remove the "edit this page" links.
					// editUrl:
					// "https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/",
				},
				theme: {
					customCss: "./src/css/custom.css",
				},
			} satisfies Preset.Options,
		],
	],

	themeConfig: {
		// Replace with your project's social card
		// image: "img/docusaurus-social-card.jpg",
		navbar: {
			title: "Cours EPSI B3 Data/IA",
			logo: {
				src: "/img/logo.png",
				srcDark: "/img/logo.png",
			},
			items: [
				{
					href: "/docs/cours",
					position: "left",
					label: "Cours",
				},
				{
					href: "/docs/events",
					position: "left",
					label: "Évenements",
				},

				// {
				//   type: "docSidebar",
				//   sidebarId: "blog",
				//   position: "left",
				//   label: "Blog",
				// },

				// {
				//   href: "/blog",
				//   label: "Blog",
				//   position: "left",
				// },
				{
					href: "https://github.com/bahAilime/coursEPSI",
					position: "right",
					className: "header-github-link",
					"aria-label": "GitHub repository",
				},
				// {
				// 	href: "https://discord.com/invite/XXXXX",
				// 	position: "right",
				// 	className: "header-discord-link",
				// 	"aria-label": "Discord server",
				// },
			],
		},
		footer: {
			logo: {
				src: "img/croqui.png",
				height: 100,
			},
			style: "light",
			links: [
				{
					title: "Cours",
					items: [
						{
							label: "Agile",
							to: "docs/cours/agile",
						},
						{
							label: "NoSQL",
							to: "docs/cours/NoSql",
						},
						{
							label: "ML et IA",
							to: "docs/cours/ML%20et%20IA",
						},
						{
							label: "Langage R",
							to: "docs/cours/Langage%20R",
						},
					],
				},
				{
					title: "Salon de la data",
					items: [
						{
							label: "Engorgement des Urgences",
							to: "docs/events/salon_de_la_data/donnee_publique_en_2024",
						},
						{
							label: "Donnée publique en 2024",
							to: "docs/events/salon_de_la_data/engorgement_des_urgences",
						},
					],
				}
			],
			copyright: `Copyright © ${new Date().getFullYear()} Emilia Beguin`,
		},
		prism: {
			additionalLanguages: ['r'],
			theme: prismThemes.github,
			darkTheme: prismThemes.dracula,
		},
	} satisfies Preset.ThemeConfig,
	plugins: [
		require.resolve("docusaurus-lunr-search"),
		// [
		// 	'@docusaurus/plugin-google-gtag',
		// 	{
		// 	  trackingID: process.env.GTAG,
		// 	  anonymizeIP: true,
		// 	},
		//   ],
		// [
		// 	'@docusaurus/plugin-content-docs',
		// 	{
		// 	  id: 'cours',
		// 	  path: 'cours',
		// 	  routeBasePath: 'cours',
		// 	//   sidebarPath: './sidebarsProduct.js',
		// 	  // ... other options
		// 	},
		//   ],
		//   [
		// 	'@docusaurus/plugin-content-docs',
		// 	{
		// 	  id: 'autre',
		// 	  path: 'autre',
		// 	  routeBasePath: 'autre',
		// 	//   sidebarPath: './sidebarsCommunity.js',
		// 	  // ... other options
		// 	},
		//   ],
	
	],
};

export default config;
