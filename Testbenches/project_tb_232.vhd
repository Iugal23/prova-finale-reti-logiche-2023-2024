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

constant SCENARIO_LENGTH : integer := 475;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (196,0,64,0,77,0,189,0,0,0,88,0,0,0,45,0,179,0,164,0,97,0,255,0,243,0,225,0,14,0,124,0,15,0,30,0,210,0,216,0,167,0,110,0,0,0,194,0,242,0,59,0,233,0,201,0,236,0,129,0,34,0,26,0,50,0,54,0,10,0,60,0,0,0,207,0,199,0,32,0,204,0,232,0,0,0,162,0,146,0,0,0,200,0,85,0,226,0,212,0,53,0,150,0,229,0,0,0,0,0,187,0,0,0,2,0,41,0,149,0,123,0,64,0,0,0,2,0,45,0,235,0,74,0,25,0,5,0,0,0,38,0,95,0,118,0,96,0,79,0,44,0,9,0,37,0,0,0,0,0,54,0,0,0,0,0,0,0,13,0,66,0,14,0,103,0,140,0,242,0,0,0,58,0,182,0,68,0,176,0,14,0,62,0,0,0,89,0,94,0,0,0,243,0,80,0,70,0,110,0,240,0,252,0,146,0,61,0,30,0,0,0,84,0,56,0,41,0,245,0,213,0,207,0,192,0,101,0,151,0,0,0,202,0,99,0,135,0,114,0,194,0,227,0,52,0,199,0,219,0,150,0,32,0,68,0,99,0,0,0,145,0,66,0,118,0,0,0,233,0,42,0,80,0,210,0,0,0,230,0,218,0,200,0,222,0,0,0,14,0,234,0,0,0,153,0,104,0,248,0,249,0,8,0,0,0,190,0,105,0,0,0,100,0,140,0,119,0,0,0,43,0,96,0,200,0,65,0,0,0,217,0,179,0,73,0,144,0,94,0,0,0,171,0,162,0,221,0,236,0,166,0,242,0,0,0,204,0,181,0,6,0,151,0,208,0,0,0,222,0,0,0,177,0,167,0,19,0,0,0,151,0,254,0,98,0,15,0,224,0,177,0,3,0,189,0,0,0,208,0,10,0,39,0,117,0,36,0,117,0,243,0,0,0,0,0,3,0,16,0,2,0,241,0,19,0,135,0,132,0,75,0,0,0,214,0,139,0,8,0,122,0,2,0,138,0,42,0,190,0,108,0,223,0,188,0,26,0,0,0,44,0,16,0,196,0,70,0,235,0,255,0,0,0,0,0,56,0,8,0,89,0,118,0,172,0,0,0,187,0,161,0,234,0,0,0,169,0,238,0,232,0,254,0,187,0,0,0,0,0,73,0,15,0,238,0,170,0,181,0,24,0,83,0,0,0,165,0,0,0,0,0,0,0,33,0,0,0,158,0,234,0,164,0,110,0,179,0,121,0,117,0,39,0,148,0,0,0,242,0,86,0,242,0,219,0,0,0,0,0,247,0,27,0,0,0,165,0,197,0,171,0,125,0,32,0,0,0,176,0,33,0,0,0,186,0,198,0,109,0,3,0,98,0,116,0,29,0,184,0,0,0,237,0,154,0,5,0,71,0,109,0,87,0,0,0,18,0,147,0,81,0,80,0,0,0,90,0,83,0,17,0,75,0,73,0,41,0,0,0,111,0,65,0,22,0,91,0,132,0,228,0,122,0,216,0,48,0,175,0,0,0,0,0,127,0,49,0,0,0,0,0,181,0,17,0,165,0,0,0,0,0,168,0,232,0,80,0,183,0,0,0,159,0,0,0,145,0,0,0,74,0,156,0,38,0,191,0,0,0,0,0,234,0,161,0,70,0,0,0,239,0,138,0,83,0,40,0,160,0,249,0,0,0,243,0,59,0,178,0,111,0,255,0,236,0,216,0,123,0,82,0,82,0,206,0,97,0,232,0,196,0,196,0,0,0,0,0,24,0,61,0,226,0,228,0,73,0,162,0,0,0,103,0,138,0,183,0,0,0,112,0,164,0,191,0,116,0,54,0,245,0,18,0,149,0,164,0,232,0,0,0,135,0,250,0,124,0,196,0,190,0,73,0,64,0,0,0,168,0,74,0,82,0,71,0,169,0,99,0,117,0,3,0,0,0,224,0,34,0,35,0,152,0,151,0,0,0,41,0,204,0,225,0,102,0,168,0,224,0,10,0,30,0,0,0,14,0,244,0,76,0,46,0,254,0,209,0,187,0,0,0,170,0,0,0,253,0,94,0,85,0,140,0,0,0,175,0,128,0,70,0,5,0,122,0,200,0,69,0,109,0,121,0,195,0,3,0,0,0);
signal scenario_full  : scenario_type := (196,31,64,31,77,31,189,31,189,30,88,31,88,30,45,31,179,31,164,31,97,31,255,31,243,31,225,31,14,31,124,31,15,31,30,31,210,31,216,31,167,31,110,31,110,30,194,31,242,31,59,31,233,31,201,31,236,31,129,31,34,31,26,31,50,31,54,31,10,31,60,31,60,30,207,31,199,31,32,31,204,31,232,31,232,30,162,31,146,31,146,30,200,31,85,31,226,31,212,31,53,31,150,31,229,31,229,30,229,29,187,31,187,30,2,31,41,31,149,31,123,31,64,31,64,30,2,31,45,31,235,31,74,31,25,31,5,31,5,30,38,31,95,31,118,31,96,31,79,31,44,31,9,31,37,31,37,30,37,29,54,31,54,30,54,29,54,28,13,31,66,31,14,31,103,31,140,31,242,31,242,30,58,31,182,31,68,31,176,31,14,31,62,31,62,30,89,31,94,31,94,30,243,31,80,31,70,31,110,31,240,31,252,31,146,31,61,31,30,31,30,30,84,31,56,31,41,31,245,31,213,31,207,31,192,31,101,31,151,31,151,30,202,31,99,31,135,31,114,31,194,31,227,31,52,31,199,31,219,31,150,31,32,31,68,31,99,31,99,30,145,31,66,31,118,31,118,30,233,31,42,31,80,31,210,31,210,30,230,31,218,31,200,31,222,31,222,30,14,31,234,31,234,30,153,31,104,31,248,31,249,31,8,31,8,30,190,31,105,31,105,30,100,31,140,31,119,31,119,30,43,31,96,31,200,31,65,31,65,30,217,31,179,31,73,31,144,31,94,31,94,30,171,31,162,31,221,31,236,31,166,31,242,31,242,30,204,31,181,31,6,31,151,31,208,31,208,30,222,31,222,30,177,31,167,31,19,31,19,30,151,31,254,31,98,31,15,31,224,31,177,31,3,31,189,31,189,30,208,31,10,31,39,31,117,31,36,31,117,31,243,31,243,30,243,29,3,31,16,31,2,31,241,31,19,31,135,31,132,31,75,31,75,30,214,31,139,31,8,31,122,31,2,31,138,31,42,31,190,31,108,31,223,31,188,31,26,31,26,30,44,31,16,31,196,31,70,31,235,31,255,31,255,30,255,29,56,31,8,31,89,31,118,31,172,31,172,30,187,31,161,31,234,31,234,30,169,31,238,31,232,31,254,31,187,31,187,30,187,29,73,31,15,31,238,31,170,31,181,31,24,31,83,31,83,30,165,31,165,30,165,29,165,28,33,31,33,30,158,31,234,31,164,31,110,31,179,31,121,31,117,31,39,31,148,31,148,30,242,31,86,31,242,31,219,31,219,30,219,29,247,31,27,31,27,30,165,31,197,31,171,31,125,31,32,31,32,30,176,31,33,31,33,30,186,31,198,31,109,31,3,31,98,31,116,31,29,31,184,31,184,30,237,31,154,31,5,31,71,31,109,31,87,31,87,30,18,31,147,31,81,31,80,31,80,30,90,31,83,31,17,31,75,31,73,31,41,31,41,30,111,31,65,31,22,31,91,31,132,31,228,31,122,31,216,31,48,31,175,31,175,30,175,29,127,31,49,31,49,30,49,29,181,31,17,31,165,31,165,30,165,29,168,31,232,31,80,31,183,31,183,30,159,31,159,30,145,31,145,30,74,31,156,31,38,31,191,31,191,30,191,29,234,31,161,31,70,31,70,30,239,31,138,31,83,31,40,31,160,31,249,31,249,30,243,31,59,31,178,31,111,31,255,31,236,31,216,31,123,31,82,31,82,31,206,31,97,31,232,31,196,31,196,31,196,30,196,29,24,31,61,31,226,31,228,31,73,31,162,31,162,30,103,31,138,31,183,31,183,30,112,31,164,31,191,31,116,31,54,31,245,31,18,31,149,31,164,31,232,31,232,30,135,31,250,31,124,31,196,31,190,31,73,31,64,31,64,30,168,31,74,31,82,31,71,31,169,31,99,31,117,31,3,31,3,30,224,31,34,31,35,31,152,31,151,31,151,30,41,31,204,31,225,31,102,31,168,31,224,31,10,31,30,31,30,30,14,31,244,31,76,31,46,31,254,31,209,31,187,31,187,30,170,31,170,30,253,31,94,31,85,31,140,31,140,30,175,31,128,31,70,31,5,31,122,31,200,31,69,31,109,31,121,31,195,31,3,31,3,30);

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
