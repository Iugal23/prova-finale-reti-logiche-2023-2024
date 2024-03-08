-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_772 is
end project_tb_772;

architecture project_tb_arch_772 of project_tb_772 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 199;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (169,0,50,0,244,0,29,0,89,0,210,0,126,0,17,0,223,0,0,0,80,0,101,0,163,0,80,0,57,0,98,0,193,0,193,0,242,0,10,0,87,0,66,0,21,0,41,0,170,0,161,0,0,0,13,0,0,0,254,0,184,0,133,0,164,0,0,0,0,0,142,0,15,0,173,0,254,0,184,0,98,0,66,0,0,0,84,0,0,0,0,0,234,0,209,0,112,0,196,0,60,0,95,0,0,0,198,0,99,0,137,0,0,0,153,0,45,0,93,0,160,0,0,0,71,0,150,0,184,0,174,0,0,0,0,0,70,0,236,0,0,0,18,0,1,0,3,0,44,0,124,0,184,0,97,0,84,0,86,0,111,0,61,0,134,0,139,0,141,0,170,0,0,0,55,0,195,0,142,0,203,0,50,0,147,0,0,0,229,0,156,0,203,0,74,0,0,0,0,0,178,0,165,0,160,0,71,0,131,0,148,0,0,0,178,0,215,0,0,0,38,0,114,0,125,0,206,0,57,0,162,0,0,0,66,0,139,0,0,0,176,0,63,0,0,0,16,0,0,0,43,0,211,0,173,0,156,0,107,0,100,0,20,0,42,0,244,0,225,0,68,0,178,0,251,0,126,0,186,0,134,0,2,0,0,0,38,0,39,0,0,0,146,0,0,0,255,0,0,0,113,0,0,0,238,0,220,0,169,0,116,0,1,0,126,0,123,0,109,0,57,0,185,0,0,0,194,0,136,0,118,0,242,0,204,0,170,0,31,0,190,0,0,0,177,0,63,0,156,0,10,0,151,0,120,0,0,0,209,0,0,0,187,0,0,0,16,0,126,0,0,0,2,0,0,0,100,0,178,0,18,0,211,0,0,0,20,0,0,0,0,0,182,0,0,0,139,0);
signal scenario_full  : scenario_type := (169,31,50,31,244,31,29,31,89,31,210,31,126,31,17,31,223,31,223,30,80,31,101,31,163,31,80,31,57,31,98,31,193,31,193,31,242,31,10,31,87,31,66,31,21,31,41,31,170,31,161,31,161,30,13,31,13,30,254,31,184,31,133,31,164,31,164,30,164,29,142,31,15,31,173,31,254,31,184,31,98,31,66,31,66,30,84,31,84,30,84,29,234,31,209,31,112,31,196,31,60,31,95,31,95,30,198,31,99,31,137,31,137,30,153,31,45,31,93,31,160,31,160,30,71,31,150,31,184,31,174,31,174,30,174,29,70,31,236,31,236,30,18,31,1,31,3,31,44,31,124,31,184,31,97,31,84,31,86,31,111,31,61,31,134,31,139,31,141,31,170,31,170,30,55,31,195,31,142,31,203,31,50,31,147,31,147,30,229,31,156,31,203,31,74,31,74,30,74,29,178,31,165,31,160,31,71,31,131,31,148,31,148,30,178,31,215,31,215,30,38,31,114,31,125,31,206,31,57,31,162,31,162,30,66,31,139,31,139,30,176,31,63,31,63,30,16,31,16,30,43,31,211,31,173,31,156,31,107,31,100,31,20,31,42,31,244,31,225,31,68,31,178,31,251,31,126,31,186,31,134,31,2,31,2,30,38,31,39,31,39,30,146,31,146,30,255,31,255,30,113,31,113,30,238,31,220,31,169,31,116,31,1,31,126,31,123,31,109,31,57,31,185,31,185,30,194,31,136,31,118,31,242,31,204,31,170,31,31,31,190,31,190,30,177,31,63,31,156,31,10,31,151,31,120,31,120,30,209,31,209,30,187,31,187,30,16,31,126,31,126,30,2,31,2,30,100,31,178,31,18,31,211,31,211,30,20,31,20,30,20,29,182,31,182,30,139,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
