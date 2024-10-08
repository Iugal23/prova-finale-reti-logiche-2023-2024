-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_150 is
end project_tb_150;

architecture project_tb_arch_150 of project_tb_150 is
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

constant SCENARIO_LENGTH : integer := 226;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,100,0,20,0,178,0,158,0,84,0,207,0,41,0,33,0,122,0,82,0,238,0,220,0,7,0,78,0,6,0,103,0,208,0,121,0,171,0,44,0,26,0,63,0,224,0,234,0,0,0,233,0,152,0,41,0,134,0,167,0,93,0,208,0,0,0,126,0,86,0,209,0,0,0,0,0,164,0,69,0,248,0,167,0,174,0,186,0,0,0,183,0,110,0,0,0,96,0,176,0,111,0,161,0,0,0,0,0,168,0,4,0,233,0,17,0,131,0,0,0,1,0,159,0,0,0,0,0,199,0,166,0,26,0,122,0,0,0,98,0,128,0,19,0,86,0,158,0,129,0,0,0,0,0,0,0,0,0,183,0,131,0,53,0,54,0,174,0,81,0,98,0,56,0,78,0,176,0,230,0,182,0,114,0,46,0,252,0,10,0,177,0,175,0,0,0,193,0,215,0,119,0,41,0,0,0,158,0,141,0,164,0,61,0,241,0,161,0,112,0,192,0,0,0,53,0,3,0,209,0,232,0,183,0,0,0,0,0,156,0,43,0,115,0,144,0,201,0,121,0,114,0,0,0,100,0,7,0,14,0,41,0,151,0,197,0,246,0,185,0,208,0,246,0,187,0,3,0,0,0,209,0,151,0,74,0,43,0,115,0,206,0,106,0,102,0,77,0,0,0,85,0,211,0,130,0,169,0,49,0,99,0,15,0,0,0,172,0,48,0,83,0,240,0,164,0,0,0,253,0,0,0,192,0,142,0,0,0,0,0,252,0,71,0,40,0,49,0,200,0,101,0,222,0,0,0,11,0,237,0,57,0,185,0,0,0,242,0,233,0,56,0,253,0,250,0,160,0,44,0,0,0,168,0,0,0,190,0,75,0,0,0,98,0,215,0,0,0,173,0,38,0,0,0,172,0,189,0,0,0,227,0,25,0,24,0,149,0,248,0,192,0,234,0,251,0,64,0,0,0,104,0,87,0,42,0,158,0,92,0,95,0,125,0,0,0,229,0,13,0);
signal scenario_full  : scenario_type := (0,0,100,31,20,31,178,31,158,31,84,31,207,31,41,31,33,31,122,31,82,31,238,31,220,31,7,31,78,31,6,31,103,31,208,31,121,31,171,31,44,31,26,31,63,31,224,31,234,31,234,30,233,31,152,31,41,31,134,31,167,31,93,31,208,31,208,30,126,31,86,31,209,31,209,30,209,29,164,31,69,31,248,31,167,31,174,31,186,31,186,30,183,31,110,31,110,30,96,31,176,31,111,31,161,31,161,30,161,29,168,31,4,31,233,31,17,31,131,31,131,30,1,31,159,31,159,30,159,29,199,31,166,31,26,31,122,31,122,30,98,31,128,31,19,31,86,31,158,31,129,31,129,30,129,29,129,28,129,27,183,31,131,31,53,31,54,31,174,31,81,31,98,31,56,31,78,31,176,31,230,31,182,31,114,31,46,31,252,31,10,31,177,31,175,31,175,30,193,31,215,31,119,31,41,31,41,30,158,31,141,31,164,31,61,31,241,31,161,31,112,31,192,31,192,30,53,31,3,31,209,31,232,31,183,31,183,30,183,29,156,31,43,31,115,31,144,31,201,31,121,31,114,31,114,30,100,31,7,31,14,31,41,31,151,31,197,31,246,31,185,31,208,31,246,31,187,31,3,31,3,30,209,31,151,31,74,31,43,31,115,31,206,31,106,31,102,31,77,31,77,30,85,31,211,31,130,31,169,31,49,31,99,31,15,31,15,30,172,31,48,31,83,31,240,31,164,31,164,30,253,31,253,30,192,31,142,31,142,30,142,29,252,31,71,31,40,31,49,31,200,31,101,31,222,31,222,30,11,31,237,31,57,31,185,31,185,30,242,31,233,31,56,31,253,31,250,31,160,31,44,31,44,30,168,31,168,30,190,31,75,31,75,30,98,31,215,31,215,30,173,31,38,31,38,30,172,31,189,31,189,30,227,31,25,31,24,31,149,31,248,31,192,31,234,31,251,31,64,31,64,30,104,31,87,31,42,31,158,31,92,31,95,31,125,31,125,30,229,31,13,31);

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
