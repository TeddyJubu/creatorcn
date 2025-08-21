import path from "path";

/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable standalone output for Docker containers
  output: 'standalone',
  turbopack: {
      rules: {
        '*.svg': {
          loaders: [
            {
              loader: '@svgr/webpack',
              options: {
                icon: true,
              },
            },
          ],
        as: '*.js',
      },
    },
  },
};

export default nextConfig;
