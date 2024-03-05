-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 384;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (216,0,0,0,44,0,246,0,112,0,72,0,107,0,150,0,0,0,0,0,26,0,230,0,192,0,0,0,87,0,162,0,135,0,189,0,133,0,0,0,185,0,0,0,148,0,234,0,142,0,202,0,190,0,0,0,0,0,0,0,22,0,154,0,203,0,117,0,0,0,236,0,0,0,239,0,0,0,44,0,104,0,244,0,41,0,211,0,0,0,0,0,0,0,117,0,202,0,110,0,163,0,0,0,47,0,111,0,235,0,0,0,110,0,0,0,103,0,145,0,100,0,10,0,13,0,0,0,77,0,81,0,101,0,23,0,185,0,218,0,0,0,108,0,136,0,29,0,125,0,0,0,171,0,200,0,185,0,0,0,0,0,105,0,81,0,63,0,209,0,0,0,238,0,103,0,50,0,128,0,188,0,0,0,95,0,135,0,8,0,238,0,82,0,0,0,64,0,223,0,209,0,0,0,32,0,199,0,46,0,245,0,72,0,51,0,120,0,0,0,91,0,106,0,234,0,207,0,23,0,103,0,100,0,0,0,181,0,0,0,41,0,84,0,158,0,72,0,254,0,214,0,10,0,180,0,26,0,211,0,139,0,80,0,68,0,17,0,4,0,25,0,101,0,253,0,172,0,74,0,144,0,158,0,0,0,248,0,18,0,25,0,52,0,21,0,224,0,0,0,32,0,120,0,0,0,177,0,0,0,239,0,212,0,93,0,0,0,213,0,129,0,182,0,149,0,206,0,29,0,208,0,25,0,42,0,189,0,116,0,224,0,0,0,255,0,192,0,38,0,47,0,205,0,106,0,107,0,0,0,145,0,74,0,171,0,147,0,0,0,151,0,0,0,126,0,93,0,121,0,200,0,141,0,143,0,163,0,123,0,213,0,180,0,189,0,167,0,251,0,87,0,126,0,250,0,33,0,131,0,149,0,18,0,171,0,214,0,0,0,210,0,200,0,246,0,115,0,0,0,175,0,103,0,140,0,49,0,0,0,41,0,210,0,110,0,0,0,65,0,78,0,0,0,131,0,214,0,253,0,173,0,138,0,126,0,0,0,251,0,0,0,0,0,77,0,97,0,56,0,71,0,175,0,0,0,0,0,103,0,188,0,149,0,222,0,35,0,83,0,113,0,0,0,156,0,0,0,0,0,52,0,158,0,0,0,25,0,16,0,39,0,0,0,139,0,6,0,103,0,51,0,35,0,81,0,166,0,29,0,180,0,0,0,122,0,128,0,94,0,125,0,255,0,113,0,15,0,171,0,100,0,0,0,169,0,194,0,247,0,190,0,236,0,0,0,91,0,226,0,0,0,50,0,238,0,0,0,41,0,202,0,25,0,82,0,0,0,185,0,254,0,96,0,170,0,210,0,176,0,119,0,196,0,120,0,9,0,53,0,3,0,157,0,0,0,126,0,0,0,135,0,143,0,76,0,0,0,0,0,184,0,0,0,176,0,107,0,0,0,0,0,72,0,96,0,47,0,180,0,61,0,17,0,54,0,242,0,142,0,65,0,44,0,153,0,7,0,0,0,78,0,175,0,153,0,0,0,198,0,252,0,0,0,187,0,207,0,251,0,199,0,83,0,0,0,153,0,85,0,46,0,0,0,126,0,0,0,245,0,132,0,81,0,84,0,15,0,0,0,0,0,95,0,194,0,121,0,56,0,0,0,117,0,242,0,24,0,249,0,0,0,253,0,92,0,201,0,0,0,65,0,0,0,157,0,231,0);
signal scenario_full  : scenario_type := (216,31,216,30,44,31,246,31,112,31,72,31,107,31,150,31,150,30,150,29,26,31,230,31,192,31,192,30,87,31,162,31,135,31,189,31,133,31,133,30,185,31,185,30,148,31,234,31,142,31,202,31,190,31,190,30,190,29,190,28,22,31,154,31,203,31,117,31,117,30,236,31,236,30,239,31,239,30,44,31,104,31,244,31,41,31,211,31,211,30,211,29,211,28,117,31,202,31,110,31,163,31,163,30,47,31,111,31,235,31,235,30,110,31,110,30,103,31,145,31,100,31,10,31,13,31,13,30,77,31,81,31,101,31,23,31,185,31,218,31,218,30,108,31,136,31,29,31,125,31,125,30,171,31,200,31,185,31,185,30,185,29,105,31,81,31,63,31,209,31,209,30,238,31,103,31,50,31,128,31,188,31,188,30,95,31,135,31,8,31,238,31,82,31,82,30,64,31,223,31,209,31,209,30,32,31,199,31,46,31,245,31,72,31,51,31,120,31,120,30,91,31,106,31,234,31,207,31,23,31,103,31,100,31,100,30,181,31,181,30,41,31,84,31,158,31,72,31,254,31,214,31,10,31,180,31,26,31,211,31,139,31,80,31,68,31,17,31,4,31,25,31,101,31,253,31,172,31,74,31,144,31,158,31,158,30,248,31,18,31,25,31,52,31,21,31,224,31,224,30,32,31,120,31,120,30,177,31,177,30,239,31,212,31,93,31,93,30,213,31,129,31,182,31,149,31,206,31,29,31,208,31,25,31,42,31,189,31,116,31,224,31,224,30,255,31,192,31,38,31,47,31,205,31,106,31,107,31,107,30,145,31,74,31,171,31,147,31,147,30,151,31,151,30,126,31,93,31,121,31,200,31,141,31,143,31,163,31,123,31,213,31,180,31,189,31,167,31,251,31,87,31,126,31,250,31,33,31,131,31,149,31,18,31,171,31,214,31,214,30,210,31,200,31,246,31,115,31,115,30,175,31,103,31,140,31,49,31,49,30,41,31,210,31,110,31,110,30,65,31,78,31,78,30,131,31,214,31,253,31,173,31,138,31,126,31,126,30,251,31,251,30,251,29,77,31,97,31,56,31,71,31,175,31,175,30,175,29,103,31,188,31,149,31,222,31,35,31,83,31,113,31,113,30,156,31,156,30,156,29,52,31,158,31,158,30,25,31,16,31,39,31,39,30,139,31,6,31,103,31,51,31,35,31,81,31,166,31,29,31,180,31,180,30,122,31,128,31,94,31,125,31,255,31,113,31,15,31,171,31,100,31,100,30,169,31,194,31,247,31,190,31,236,31,236,30,91,31,226,31,226,30,50,31,238,31,238,30,41,31,202,31,25,31,82,31,82,30,185,31,254,31,96,31,170,31,210,31,176,31,119,31,196,31,120,31,9,31,53,31,3,31,157,31,157,30,126,31,126,30,135,31,143,31,76,31,76,30,76,29,184,31,184,30,176,31,107,31,107,30,107,29,72,31,96,31,47,31,180,31,61,31,17,31,54,31,242,31,142,31,65,31,44,31,153,31,7,31,7,30,78,31,175,31,153,31,153,30,198,31,252,31,252,30,187,31,207,31,251,31,199,31,83,31,83,30,153,31,85,31,46,31,46,30,126,31,126,30,245,31,132,31,81,31,84,31,15,31,15,30,15,29,95,31,194,31,121,31,56,31,56,30,117,31,242,31,24,31,249,31,249,30,253,31,92,31,201,31,201,30,65,31,65,30,157,31,231,31);

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
