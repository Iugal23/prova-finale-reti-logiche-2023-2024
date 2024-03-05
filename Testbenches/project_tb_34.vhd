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

constant SCENARIO_LENGTH : integer := 444;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (188,0,95,0,176,0,18,0,0,0,42,0,60,0,88,0,219,0,202,0,185,0,199,0,6,0,169,0,0,0,146,0,231,0,118,0,24,0,0,0,185,0,0,0,103,0,0,0,0,0,198,0,123,0,144,0,4,0,15,0,190,0,52,0,43,0,225,0,0,0,163,0,206,0,162,0,231,0,248,0,41,0,0,0,0,0,90,0,109,0,21,0,49,0,68,0,0,0,0,0,203,0,0,0,225,0,210,0,0,0,0,0,8,0,4,0,162,0,0,0,130,0,0,0,22,0,176,0,198,0,192,0,130,0,249,0,0,0,52,0,220,0,44,0,45,0,76,0,231,0,120,0,0,0,0,0,0,0,7,0,61,0,163,0,116,0,0,0,0,0,19,0,46,0,20,0,117,0,242,0,123,0,235,0,78,0,0,0,97,0,240,0,0,0,89,0,2,0,19,0,139,0,129,0,164,0,186,0,0,0,112,0,153,0,149,0,49,0,122,0,102,0,67,0,0,0,0,0,114,0,144,0,0,0,0,0,128,0,157,0,0,0,14,0,0,0,31,0,142,0,65,0,46,0,184,0,84,0,0,0,0,0,13,0,189,0,77,0,240,0,203,0,138,0,45,0,242,0,31,0,12,0,76,0,0,0,107,0,75,0,35,0,0,0,109,0,240,0,220,0,0,0,117,0,0,0,139,0,0,0,0,0,42,0,31,0,0,0,199,0,105,0,155,0,0,0,0,0,121,0,135,0,2,0,207,0,204,0,226,0,0,0,140,0,168,0,204,0,156,0,0,0,9,0,239,0,75,0,173,0,114,0,0,0,0,0,175,0,250,0,204,0,121,0,0,0,217,0,236,0,237,0,71,0,0,0,42,0,97,0,207,0,164,0,0,0,0,0,0,0,142,0,7,0,180,0,12,0,77,0,9,0,0,0,186,0,130,0,211,0,209,0,216,0,214,0,183,0,0,0,104,0,157,0,187,0,255,0,0,0,0,0,119,0,177,0,0,0,10,0,110,0,191,0,21,0,127,0,65,0,120,0,184,0,82,0,9,0,35,0,136,0,255,0,100,0,198,0,239,0,142,0,216,0,0,0,46,0,129,0,224,0,127,0,213,0,0,0,0,0,0,0,93,0,115,0,166,0,99,0,150,0,112,0,103,0,102,0,0,0,16,0,0,0,54,0,158,0,0,0,102,0,134,0,140,0,130,0,164,0,87,0,15,0,62,0,1,0,235,0,212,0,0,0,10,0,143,0,15,0,0,0,0,0,183,0,42,0,222,0,149,0,212,0,235,0,101,0,121,0,0,0,0,0,238,0,136,0,0,0,0,0,87,0,205,0,98,0,0,0,95,0,93,0,252,0,197,0,158,0,0,0,97,0,242,0,132,0,37,0,72,0,79,0,102,0,109,0,219,0,119,0,107,0,0,0,102,0,0,0,30,0,33,0,213,0,231,0,153,0,0,0,157,0,210,0,218,0,220,0,119,0,0,0,199,0,165,0,30,0,196,0,224,0,11,0,2,0,114,0,173,0,5,0,162,0,244,0,10,0,4,0,161,0,186,0,178,0,0,0,0,0,76,0,0,0,28,0,0,0,56,0,183,0,83,0,0,0,35,0,27,0,17,0,92,0,0,0,165,0,137,0,0,0,183,0,153,0,0,0,51,0,111,0,217,0,210,0,0,0,206,0,186,0,183,0,0,0,145,0,91,0,151,0,153,0,238,0,0,0,48,0,231,0,195,0,3,0,183,0,245,0,122,0,136,0,157,0,60,0,122,0,159,0,201,0,97,0,141,0,194,0,111,0,11,0,246,0,235,0,35,0,0,0,0,0,210,0,0,0,0,0,76,0,169,0,51,0,253,0,0,0,202,0,223,0,0,0,218,0,205,0,232,0,219,0,152,0,126,0,63,0,204,0,0,0,135,0,238,0,167,0,41,0,106,0,55,0,73,0,140,0,81,0,184,0,0,0,150,0,60,0,0,0,168,0,208,0);
signal scenario_full  : scenario_type := (188,31,95,31,176,31,18,31,18,30,42,31,60,31,88,31,219,31,202,31,185,31,199,31,6,31,169,31,169,30,146,31,231,31,118,31,24,31,24,30,185,31,185,30,103,31,103,30,103,29,198,31,123,31,144,31,4,31,15,31,190,31,52,31,43,31,225,31,225,30,163,31,206,31,162,31,231,31,248,31,41,31,41,30,41,29,90,31,109,31,21,31,49,31,68,31,68,30,68,29,203,31,203,30,225,31,210,31,210,30,210,29,8,31,4,31,162,31,162,30,130,31,130,30,22,31,176,31,198,31,192,31,130,31,249,31,249,30,52,31,220,31,44,31,45,31,76,31,231,31,120,31,120,30,120,29,120,28,7,31,61,31,163,31,116,31,116,30,116,29,19,31,46,31,20,31,117,31,242,31,123,31,235,31,78,31,78,30,97,31,240,31,240,30,89,31,2,31,19,31,139,31,129,31,164,31,186,31,186,30,112,31,153,31,149,31,49,31,122,31,102,31,67,31,67,30,67,29,114,31,144,31,144,30,144,29,128,31,157,31,157,30,14,31,14,30,31,31,142,31,65,31,46,31,184,31,84,31,84,30,84,29,13,31,189,31,77,31,240,31,203,31,138,31,45,31,242,31,31,31,12,31,76,31,76,30,107,31,75,31,35,31,35,30,109,31,240,31,220,31,220,30,117,31,117,30,139,31,139,30,139,29,42,31,31,31,31,30,199,31,105,31,155,31,155,30,155,29,121,31,135,31,2,31,207,31,204,31,226,31,226,30,140,31,168,31,204,31,156,31,156,30,9,31,239,31,75,31,173,31,114,31,114,30,114,29,175,31,250,31,204,31,121,31,121,30,217,31,236,31,237,31,71,31,71,30,42,31,97,31,207,31,164,31,164,30,164,29,164,28,142,31,7,31,180,31,12,31,77,31,9,31,9,30,186,31,130,31,211,31,209,31,216,31,214,31,183,31,183,30,104,31,157,31,187,31,255,31,255,30,255,29,119,31,177,31,177,30,10,31,110,31,191,31,21,31,127,31,65,31,120,31,184,31,82,31,9,31,35,31,136,31,255,31,100,31,198,31,239,31,142,31,216,31,216,30,46,31,129,31,224,31,127,31,213,31,213,30,213,29,213,28,93,31,115,31,166,31,99,31,150,31,112,31,103,31,102,31,102,30,16,31,16,30,54,31,158,31,158,30,102,31,134,31,140,31,130,31,164,31,87,31,15,31,62,31,1,31,235,31,212,31,212,30,10,31,143,31,15,31,15,30,15,29,183,31,42,31,222,31,149,31,212,31,235,31,101,31,121,31,121,30,121,29,238,31,136,31,136,30,136,29,87,31,205,31,98,31,98,30,95,31,93,31,252,31,197,31,158,31,158,30,97,31,242,31,132,31,37,31,72,31,79,31,102,31,109,31,219,31,119,31,107,31,107,30,102,31,102,30,30,31,33,31,213,31,231,31,153,31,153,30,157,31,210,31,218,31,220,31,119,31,119,30,199,31,165,31,30,31,196,31,224,31,11,31,2,31,114,31,173,31,5,31,162,31,244,31,10,31,4,31,161,31,186,31,178,31,178,30,178,29,76,31,76,30,28,31,28,30,56,31,183,31,83,31,83,30,35,31,27,31,17,31,92,31,92,30,165,31,137,31,137,30,183,31,153,31,153,30,51,31,111,31,217,31,210,31,210,30,206,31,186,31,183,31,183,30,145,31,91,31,151,31,153,31,238,31,238,30,48,31,231,31,195,31,3,31,183,31,245,31,122,31,136,31,157,31,60,31,122,31,159,31,201,31,97,31,141,31,194,31,111,31,11,31,246,31,235,31,35,31,35,30,35,29,210,31,210,30,210,29,76,31,169,31,51,31,253,31,253,30,202,31,223,31,223,30,218,31,205,31,232,31,219,31,152,31,126,31,63,31,204,31,204,30,135,31,238,31,167,31,41,31,106,31,55,31,73,31,140,31,81,31,184,31,184,30,150,31,60,31,60,30,168,31,208,31);

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
