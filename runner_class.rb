class Runner

# Runner attributes
    attr_accessor :firstname, :lastname, :sex, :xctimes, :m60times, :m60htimes, :m100times, :m200times, :m400times, :m500times, :m800times, :m1000times, :m1500times, :miletimes, :m3000times, :m3000htimes, :m5ktimes, :m10ktimes

    def initialize(first, last, sex)
        @firstname = first
        @lastname = last
        @sex = sex
        @xctimes = []
        @m60times = []
        @m60htimes = []
        @m100times = []
        @m200times = []
        @m400times = []
        @m500times = []
        @m800imes = []
        @m1000times = []
        @m1500times = []
        @miletimes = []
        @m3000times = []
        @m3000htimes = []
        @m5ktimes = []
        @m10ktimes = []
    end
    
    def add_xc_time(time)
		@xctimes.append(time)
    end
    
    def add_60_time(time)
		@m60times.append(time)
    end
    
    def add_60h_time(time)
		@m60htimes.append(time)
    end
    
    def add_100_time(time)
		@m100times.append(time)
    end
    
    def add_200_time(time)
		@m200times.append(time)
    end
    
    def add_400_time(time)
		@m400times.append(time)
    end
    
    def add_500_time(time)
		@m500times.append(time)
    end
    
    def add_800_time(time)
		@m800times.append(time)
    end
    
    def add_1000_time(time)
		@m1000times.append(time)
    end
    
    def add_1500_time(time)
		@m1500times.append(time)
    end
    
    def add_mile_time(time)
		@miletimes.append(time)
    end
    
    def add_3000_time(time)
		@m3000times.append(time)
    end
    
    def add_3000h_time(time)
		@m3000htimes.append(time)
    end
    
    def add_5k_time(time)
		@m5ktimes.append(time)
    end
    
    def add_10k_time(time)
		@m10ktimes.append(time)
    end
    
    def same_person?(first, last)
		if(@firstname == first && @lastname == last)
			return true
		end
		return false
	end

end
