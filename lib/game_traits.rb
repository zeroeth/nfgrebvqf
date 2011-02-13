require 'chingu'

module Chingu
  module Traits
    module ScreenWarp
      def update_trait
	self.x = 0 if x > $window.width
	self.y = 0 if y > $window.height

	self.x = $window.width  if x < 0
	self.y = $window.height if y < 0

	super
      end
    end

    module Vector
      def vector(magnitude=1.0)
	ajusted_angle = angle - 90
	radians = ajusted_angle * Math::PI/180.0
	return Math::cos(radians)*magnitude, Math::sin(radians)*magnitude
      end

      def velocity_magnitude
	Math::sqrt(velocity_x**2 + velocity_y**2)
      end
    end
  end
end
