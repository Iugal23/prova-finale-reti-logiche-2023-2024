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

constant SCENARIO_LENGTH : integer := 571;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (126,0,160,0,21,0,0,0,109,0,0,0,248,0,0,0,202,0,96,0,0,0,12,0,61,0,136,0,114,0,8,0,217,0,150,0,84,0,185,0,13,0,44,0,0,0,0,0,146,0,93,0,213,0,0,0,0,0,87,0,103,0,178,0,42,0,86,0,0,0,252,0,45,0,51,0,72,0,0,0,179,0,151,0,26,0,30,0,85,0,0,0,0,0,211,0,141,0,7,0,39,0,209,0,201,0,102,0,11,0,119,0,231,0,48,0,0,0,173,0,0,0,253,0,1,0,93,0,0,0,0,0,0,0,187,0,131,0,105,0,183,0,0,0,97,0,0,0,67,0,211,0,0,0,89,0,0,0,159,0,0,0,171,0,170,0,243,0,0,0,54,0,0,0,78,0,15,0,0,0,0,0,177,0,245,0,0,0,243,0,0,0,118,0,242,0,46,0,227,0,7,0,81,0,116,0,210,0,0,0,0,0,126,0,191,0,253,0,0,0,169,0,12,0,90,0,0,0,116,0,244,0,42,0,107,0,200,0,0,0,230,0,20,0,65,0,214,0,239,0,35,0,219,0,0,0,234,0,233,0,39,0,221,0,0,0,153,0,167,0,210,0,52,0,73,0,137,0,180,0,116,0,242,0,0,0,172,0,120,0,87,0,112,0,181,0,199,0,0,0,156,0,25,0,75,0,0,0,1,0,0,0,253,0,161,0,165,0,231,0,0,0,69,0,0,0,175,0,49,0,251,0,33,0,157,0,235,0,48,0,71,0,0,0,133,0,0,0,0,0,0,0,124,0,58,0,133,0,164,0,0,0,102,0,0,0,119,0,0,0,75,0,0,0,217,0,11,0,0,0,36,0,179,0,211,0,57,0,6,0,15,0,204,0,0,0,0,0,81,0,88,0,250,0,0,0,184,0,68,0,98,0,19,0,45,0,241,0,154,0,202,0,214,0,46,0,0,0,71,0,137,0,168,0,64,0,155,0,17,0,108,0,252,0,122,0,141,0,7,0,187,0,0,0,129,0,191,0,9,0,13,0,0,0,38,0,0,0,195,0,190,0,0,0,117,0,0,0,73,0,17,0,162,0,126,0,252,0,75,0,114,0,0,0,230,0,249,0,57,0,20,0,211,0,0,0,149,0,166,0,0,0,63,0,247,0,6,0,46,0,133,0,215,0,0,0,0,0,0,0,0,0,133,0,201,0,91,0,84,0,0,0,0,0,134,0,16,0,225,0,254,0,42,0,177,0,0,0,0,0,191,0,222,0,73,0,150,0,0,0,0,0,80,0,0,0,129,0,0,0,97,0,77,0,220,0,110,0,254,0,0,0,157,0,29,0,111,0,0,0,12,0,159,0,4,0,110,0,97,0,110,0,105,0,0,0,0,0,198,0,10,0,0,0,229,0,245,0,134,0,121,0,162,0,0,0,249,0,246,0,83,0,0,0,229,0,45,0,148,0,172,0,36,0,145,0,0,0,0,0,245,0,0,0,0,0,0,0,245,0,165,0,255,0,0,0,26,0,0,0,230,0,161,0,0,0,107,0,0,0,110,0,73,0,154,0,209,0,237,0,208,0,132,0,24,0,178,0,166,0,0,0,199,0,68,0,45,0,0,0,47,0,227,0,126,0,0,0,203,0,2,0,82,0,0,0,105,0,63,0,0,0,99,0,0,0,81,0,211,0,18,0,118,0,138,0,227,0,109,0,149,0,0,0,161,0,0,0,0,0,229,0,0,0,45,0,181,0,21,0,152,0,179,0,0,0,69,0,231,0,0,0,111,0,0,0,51,0,241,0,79,0,29,0,84,0,44,0,8,0,79,0,169,0,4,0,69,0,28,0,116,0,91,0,58,0,46,0,63,0,180,0,251,0,145,0,235,0,0,0,0,0,0,0,133,0,0,0,0,0,54,0,64,0,67,0,163,0,43,0,122,0,0,0,0,0,214,0,204,0,89,0,131,0,230,0,103,0,144,0,128,0,179,0,0,0,0,0,80,0,12,0,45,0,12,0,221,0,17,0,106,0,82,0,249,0,40,0,0,0,0,0,111,0,172,0,24,0,0,0,223,0,0,0,23,0,34,0,0,0,65,0,198,0,168,0,126,0,221,0,0,0,0,0,222,0,131,0,204,0,152,0,0,0,134,0,245,0,210,0,43,0,160,0,0,0,100,0,68,0,109,0,73,0,0,0,58,0,0,0,17,0,19,0,55,0,208,0,195,0,238,0,252,0,229,0,42,0,134,0,33,0,0,0,159,0,78,0,0,0,43,0,238,0,0,0,0,0,122,0,75,0,103,0,219,0,219,0,174,0,212,0,9,0,138,0,168,0,251,0,201,0,117,0,0,0,148,0,228,0,107,0,0,0,41,0,204,0,189,0,82,0,0,0,156,0,170,0,0,0,43,0,0,0,2,0,140,0,48,0,94,0,95,0,133,0,0,0,97,0,46,0,68,0,0,0,124,0,89,0,6,0,45,0,117,0,0,0,74,0,161,0,0,0,120,0,205,0,204,0,0,0,0,0,170,0,169,0,0,0,225,0,71,0,241,0,189,0,66,0,47,0);
signal scenario_full  : scenario_type := (126,31,160,31,21,31,21,30,109,31,109,30,248,31,248,30,202,31,96,31,96,30,12,31,61,31,136,31,114,31,8,31,217,31,150,31,84,31,185,31,13,31,44,31,44,30,44,29,146,31,93,31,213,31,213,30,213,29,87,31,103,31,178,31,42,31,86,31,86,30,252,31,45,31,51,31,72,31,72,30,179,31,151,31,26,31,30,31,85,31,85,30,85,29,211,31,141,31,7,31,39,31,209,31,201,31,102,31,11,31,119,31,231,31,48,31,48,30,173,31,173,30,253,31,1,31,93,31,93,30,93,29,93,28,187,31,131,31,105,31,183,31,183,30,97,31,97,30,67,31,211,31,211,30,89,31,89,30,159,31,159,30,171,31,170,31,243,31,243,30,54,31,54,30,78,31,15,31,15,30,15,29,177,31,245,31,245,30,243,31,243,30,118,31,242,31,46,31,227,31,7,31,81,31,116,31,210,31,210,30,210,29,126,31,191,31,253,31,253,30,169,31,12,31,90,31,90,30,116,31,244,31,42,31,107,31,200,31,200,30,230,31,20,31,65,31,214,31,239,31,35,31,219,31,219,30,234,31,233,31,39,31,221,31,221,30,153,31,167,31,210,31,52,31,73,31,137,31,180,31,116,31,242,31,242,30,172,31,120,31,87,31,112,31,181,31,199,31,199,30,156,31,25,31,75,31,75,30,1,31,1,30,253,31,161,31,165,31,231,31,231,30,69,31,69,30,175,31,49,31,251,31,33,31,157,31,235,31,48,31,71,31,71,30,133,31,133,30,133,29,133,28,124,31,58,31,133,31,164,31,164,30,102,31,102,30,119,31,119,30,75,31,75,30,217,31,11,31,11,30,36,31,179,31,211,31,57,31,6,31,15,31,204,31,204,30,204,29,81,31,88,31,250,31,250,30,184,31,68,31,98,31,19,31,45,31,241,31,154,31,202,31,214,31,46,31,46,30,71,31,137,31,168,31,64,31,155,31,17,31,108,31,252,31,122,31,141,31,7,31,187,31,187,30,129,31,191,31,9,31,13,31,13,30,38,31,38,30,195,31,190,31,190,30,117,31,117,30,73,31,17,31,162,31,126,31,252,31,75,31,114,31,114,30,230,31,249,31,57,31,20,31,211,31,211,30,149,31,166,31,166,30,63,31,247,31,6,31,46,31,133,31,215,31,215,30,215,29,215,28,215,27,133,31,201,31,91,31,84,31,84,30,84,29,134,31,16,31,225,31,254,31,42,31,177,31,177,30,177,29,191,31,222,31,73,31,150,31,150,30,150,29,80,31,80,30,129,31,129,30,97,31,77,31,220,31,110,31,254,31,254,30,157,31,29,31,111,31,111,30,12,31,159,31,4,31,110,31,97,31,110,31,105,31,105,30,105,29,198,31,10,31,10,30,229,31,245,31,134,31,121,31,162,31,162,30,249,31,246,31,83,31,83,30,229,31,45,31,148,31,172,31,36,31,145,31,145,30,145,29,245,31,245,30,245,29,245,28,245,31,165,31,255,31,255,30,26,31,26,30,230,31,161,31,161,30,107,31,107,30,110,31,73,31,154,31,209,31,237,31,208,31,132,31,24,31,178,31,166,31,166,30,199,31,68,31,45,31,45,30,47,31,227,31,126,31,126,30,203,31,2,31,82,31,82,30,105,31,63,31,63,30,99,31,99,30,81,31,211,31,18,31,118,31,138,31,227,31,109,31,149,31,149,30,161,31,161,30,161,29,229,31,229,30,45,31,181,31,21,31,152,31,179,31,179,30,69,31,231,31,231,30,111,31,111,30,51,31,241,31,79,31,29,31,84,31,44,31,8,31,79,31,169,31,4,31,69,31,28,31,116,31,91,31,58,31,46,31,63,31,180,31,251,31,145,31,235,31,235,30,235,29,235,28,133,31,133,30,133,29,54,31,64,31,67,31,163,31,43,31,122,31,122,30,122,29,214,31,204,31,89,31,131,31,230,31,103,31,144,31,128,31,179,31,179,30,179,29,80,31,12,31,45,31,12,31,221,31,17,31,106,31,82,31,249,31,40,31,40,30,40,29,111,31,172,31,24,31,24,30,223,31,223,30,23,31,34,31,34,30,65,31,198,31,168,31,126,31,221,31,221,30,221,29,222,31,131,31,204,31,152,31,152,30,134,31,245,31,210,31,43,31,160,31,160,30,100,31,68,31,109,31,73,31,73,30,58,31,58,30,17,31,19,31,55,31,208,31,195,31,238,31,252,31,229,31,42,31,134,31,33,31,33,30,159,31,78,31,78,30,43,31,238,31,238,30,238,29,122,31,75,31,103,31,219,31,219,31,174,31,212,31,9,31,138,31,168,31,251,31,201,31,117,31,117,30,148,31,228,31,107,31,107,30,41,31,204,31,189,31,82,31,82,30,156,31,170,31,170,30,43,31,43,30,2,31,140,31,48,31,94,31,95,31,133,31,133,30,97,31,46,31,68,31,68,30,124,31,89,31,6,31,45,31,117,31,117,30,74,31,161,31,161,30,120,31,205,31,204,31,204,30,204,29,170,31,169,31,169,30,225,31,71,31,241,31,189,31,66,31,47,31);

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
