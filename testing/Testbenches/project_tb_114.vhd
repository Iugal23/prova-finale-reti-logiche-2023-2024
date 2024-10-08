-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_114 is
end project_tb_114;

architecture project_tb_arch_114 of project_tb_114 is
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

constant SCENARIO_LENGTH : integer := 440;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,117,0,41,0,54,0,158,0,0,0,217,0,174,0,191,0,0,0,2,0,182,0,0,0,175,0,153,0,180,0,26,0,123,0,0,0,0,0,63,0,53,0,35,0,0,0,242,0,57,0,124,0,79,0,0,0,3,0,250,0,138,0,181,0,143,0,187,0,6,0,171,0,0,0,0,0,30,0,125,0,216,0,0,0,148,0,215,0,0,0,0,0,206,0,177,0,137,0,1,0,100,0,159,0,0,0,185,0,126,0,187,0,110,0,131,0,55,0,138,0,0,0,140,0,163,0,0,0,37,0,78,0,240,0,151,0,221,0,0,0,124,0,19,0,0,0,157,0,111,0,203,0,240,0,230,0,254,0,66,0,67,0,190,0,246,0,65,0,239,0,0,0,95,0,207,0,193,0,113,0,140,0,51,0,62,0,0,0,12,0,0,0,66,0,199,0,0,0,46,0,0,0,133,0,184,0,59,0,86,0,3,0,157,0,207,0,195,0,238,0,173,0,165,0,235,0,236,0,84,0,0,0,14,0,112,0,60,0,216,0,173,0,34,0,119,0,206,0,0,0,0,0,210,0,60,0,53,0,225,0,253,0,0,0,201,0,35,0,41,0,0,0,175,0,187,0,0,0,215,0,83,0,162,0,250,0,11,0,135,0,72,0,0,0,0,0,22,0,45,0,23,0,226,0,202,0,35,0,48,0,176,0,152,0,160,0,32,0,147,0,145,0,186,0,247,0,0,0,233,0,226,0,25,0,204,0,25,0,189,0,190,0,109,0,148,0,0,0,150,0,13,0,165,0,42,0,234,0,183,0,230,0,178,0,146,0,0,0,0,0,201,0,107,0,140,0,79,0,35,0,36,0,0,0,94,0,217,0,126,0,0,0,0,0,110,0,157,0,128,0,8,0,200,0,57,0,18,0,92,0,15,0,217,0,55,0,0,0,0,0,84,0,0,0,251,0,145,0,194,0,247,0,214,0,2,0,157,0,68,0,0,0,104,0,42,0,15,0,252,0,0,0,215,0,159,0,166,0,25,0,243,0,115,0,231,0,205,0,209,0,65,0,237,0,0,0,32,0,228,0,0,0,169,0,39,0,180,0,170,0,9,0,179,0,65,0,0,0,0,0,0,0,195,0,123,0,212,0,253,0,28,0,184,0,134,0,130,0,0,0,88,0,224,0,127,0,0,0,135,0,0,0,0,0,7,0,106,0,132,0,249,0,246,0,43,0,0,0,128,0,0,0,89,0,111,0,90,0,0,0,128,0,0,0,187,0,156,0,0,0,244,0,49,0,172,0,247,0,181,0,0,0,241,0,116,0,211,0,0,0,242,0,255,0,250,0,0,0,167,0,77,0,245,0,244,0,74,0,0,0,0,0,70,0,0,0,210,0,0,0,94,0,157,0,167,0,121,0,0,0,108,0,109,0,172,0,167,0,204,0,130,0,121,0,166,0,0,0,254,0,91,0,206,0,104,0,48,0,33,0,0,0,0,0,146,0,99,0,149,0,70,0,55,0,3,0,86,0,88,0,69,0,21,0,158,0,0,0,247,0,0,0,0,0,113,0,0,0,134,0,196,0,195,0,190,0,0,0,201,0,220,0,101,0,31,0,227,0,6,0,94,0,83,0,150,0,106,0,160,0,66,0,209,0,15,0,0,0,229,0,215,0,186,0,8,0,197,0,226,0,224,0,96,0,23,0,228,0,187,0,233,0,137,0,110,0,183,0,0,0,140,0,105,0,116,0,233,0,72,0,32,0,103,0,74,0,0,0,0,0,104,0,0,0,206,0,130,0,241,0,82,0,0,0,0,0,81,0,0,0,20,0,212,0,20,0,255,0,0,0,252,0,0,0,126,0,176,0,205,0,5,0,109,0,45,0,102,0,138,0,0,0,81,0,81,0,232,0,154,0,0,0,145,0,6,0,25,0,143,0,208,0,8,0,201,0,116,0,0,0,11,0,176,0,0,0,171,0);
signal scenario_full  : scenario_type := (0,0,117,31,41,31,54,31,158,31,158,30,217,31,174,31,191,31,191,30,2,31,182,31,182,30,175,31,153,31,180,31,26,31,123,31,123,30,123,29,63,31,53,31,35,31,35,30,242,31,57,31,124,31,79,31,79,30,3,31,250,31,138,31,181,31,143,31,187,31,6,31,171,31,171,30,171,29,30,31,125,31,216,31,216,30,148,31,215,31,215,30,215,29,206,31,177,31,137,31,1,31,100,31,159,31,159,30,185,31,126,31,187,31,110,31,131,31,55,31,138,31,138,30,140,31,163,31,163,30,37,31,78,31,240,31,151,31,221,31,221,30,124,31,19,31,19,30,157,31,111,31,203,31,240,31,230,31,254,31,66,31,67,31,190,31,246,31,65,31,239,31,239,30,95,31,207,31,193,31,113,31,140,31,51,31,62,31,62,30,12,31,12,30,66,31,199,31,199,30,46,31,46,30,133,31,184,31,59,31,86,31,3,31,157,31,207,31,195,31,238,31,173,31,165,31,235,31,236,31,84,31,84,30,14,31,112,31,60,31,216,31,173,31,34,31,119,31,206,31,206,30,206,29,210,31,60,31,53,31,225,31,253,31,253,30,201,31,35,31,41,31,41,30,175,31,187,31,187,30,215,31,83,31,162,31,250,31,11,31,135,31,72,31,72,30,72,29,22,31,45,31,23,31,226,31,202,31,35,31,48,31,176,31,152,31,160,31,32,31,147,31,145,31,186,31,247,31,247,30,233,31,226,31,25,31,204,31,25,31,189,31,190,31,109,31,148,31,148,30,150,31,13,31,165,31,42,31,234,31,183,31,230,31,178,31,146,31,146,30,146,29,201,31,107,31,140,31,79,31,35,31,36,31,36,30,94,31,217,31,126,31,126,30,126,29,110,31,157,31,128,31,8,31,200,31,57,31,18,31,92,31,15,31,217,31,55,31,55,30,55,29,84,31,84,30,251,31,145,31,194,31,247,31,214,31,2,31,157,31,68,31,68,30,104,31,42,31,15,31,252,31,252,30,215,31,159,31,166,31,25,31,243,31,115,31,231,31,205,31,209,31,65,31,237,31,237,30,32,31,228,31,228,30,169,31,39,31,180,31,170,31,9,31,179,31,65,31,65,30,65,29,65,28,195,31,123,31,212,31,253,31,28,31,184,31,134,31,130,31,130,30,88,31,224,31,127,31,127,30,135,31,135,30,135,29,7,31,106,31,132,31,249,31,246,31,43,31,43,30,128,31,128,30,89,31,111,31,90,31,90,30,128,31,128,30,187,31,156,31,156,30,244,31,49,31,172,31,247,31,181,31,181,30,241,31,116,31,211,31,211,30,242,31,255,31,250,31,250,30,167,31,77,31,245,31,244,31,74,31,74,30,74,29,70,31,70,30,210,31,210,30,94,31,157,31,167,31,121,31,121,30,108,31,109,31,172,31,167,31,204,31,130,31,121,31,166,31,166,30,254,31,91,31,206,31,104,31,48,31,33,31,33,30,33,29,146,31,99,31,149,31,70,31,55,31,3,31,86,31,88,31,69,31,21,31,158,31,158,30,247,31,247,30,247,29,113,31,113,30,134,31,196,31,195,31,190,31,190,30,201,31,220,31,101,31,31,31,227,31,6,31,94,31,83,31,150,31,106,31,160,31,66,31,209,31,15,31,15,30,229,31,215,31,186,31,8,31,197,31,226,31,224,31,96,31,23,31,228,31,187,31,233,31,137,31,110,31,183,31,183,30,140,31,105,31,116,31,233,31,72,31,32,31,103,31,74,31,74,30,74,29,104,31,104,30,206,31,130,31,241,31,82,31,82,30,82,29,81,31,81,30,20,31,212,31,20,31,255,31,255,30,252,31,252,30,126,31,176,31,205,31,5,31,109,31,45,31,102,31,138,31,138,30,81,31,81,31,232,31,154,31,154,30,145,31,6,31,25,31,143,31,208,31,8,31,201,31,116,31,116,30,11,31,176,31,176,30,171,31);

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
