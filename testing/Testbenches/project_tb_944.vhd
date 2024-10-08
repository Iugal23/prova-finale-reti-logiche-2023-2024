-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_944 is
end project_tb_944;

architecture project_tb_arch_944 of project_tb_944 is
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

constant SCENARIO_LENGTH : integer := 511;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (136,0,92,0,175,0,191,0,49,0,23,0,0,0,32,0,41,0,220,0,223,0,210,0,0,0,0,0,0,0,230,0,212,0,61,0,25,0,133,0,82,0,0,0,167,0,161,0,186,0,222,0,0,0,219,0,34,0,218,0,0,0,79,0,0,0,0,0,108,0,0,0,178,0,211,0,159,0,165,0,169,0,214,0,144,0,148,0,176,0,29,0,0,0,0,0,0,0,0,0,81,0,62,0,0,0,175,0,155,0,0,0,0,0,21,0,141,0,236,0,241,0,0,0,136,0,121,0,221,0,142,0,0,0,123,0,252,0,0,0,0,0,1,0,119,0,95,0,0,0,144,0,127,0,38,0,0,0,87,0,43,0,182,0,102,0,235,0,137,0,0,0,0,0,165,0,184,0,0,0,93,0,75,0,133,0,75,0,182,0,157,0,210,0,0,0,0,0,7,0,0,0,74,0,55,0,96,0,0,0,39,0,134,0,194,0,205,0,202,0,1,0,101,0,243,0,2,0,0,0,26,0,244,0,0,0,228,0,0,0,54,0,208,0,18,0,46,0,177,0,131,0,101,0,3,0,78,0,139,0,41,0,0,0,0,0,0,0,196,0,0,0,0,0,48,0,0,0,0,0,35,0,170,0,210,0,183,0,123,0,228,0,247,0,142,0,252,0,234,0,0,0,210,0,101,0,0,0,30,0,0,0,140,0,8,0,70,0,0,0,251,0,102,0,69,0,140,0,6,0,67,0,78,0,0,0,0,0,197,0,165,0,182,0,113,0,60,0,78,0,188,0,0,0,232,0,0,0,97,0,39,0,10,0,136,0,0,0,71,0,186,0,52,0,226,0,0,0,229,0,10,0,241,0,254,0,230,0,163,0,104,0,51,0,186,0,143,0,247,0,180,0,167,0,0,0,0,0,174,0,0,0,185,0,110,0,172,0,40,0,0,0,221,0,180,0,223,0,180,0,137,0,162,0,146,0,250,0,142,0,38,0,0,0,138,0,178,0,93,0,23,0,161,0,140,0,207,0,0,0,31,0,121,0,65,0,19,0,223,0,217,0,158,0,241,0,52,0,0,0,180,0,0,0,55,0,0,0,7,0,40,0,146,0,3,0,69,0,228,0,175,0,3,0,222,0,0,0,152,0,158,0,244,0,0,0,187,0,197,0,33,0,52,0,240,0,14,0,208,0,135,0,176,0,165,0,80,0,112,0,117,0,122,0,153,0,0,0,201,0,0,0,234,0,62,0,0,0,242,0,239,0,229,0,111,0,143,0,0,0,115,0,91,0,51,0,168,0,99,0,225,0,0,0,224,0,180,0,0,0,212,0,90,0,158,0,216,0,71,0,0,0,0,0,158,0,121,0,127,0,0,0,85,0,70,0,25,0,109,0,235,0,53,0,177,0,99,0,0,0,157,0,86,0,81,0,81,0,171,0,0,0,231,0,9,0,0,0,43,0,58,0,20,0,206,0,0,0,5,0,118,0,115,0,58,0,0,0,21,0,37,0,157,0,228,0,179,0,0,0,178,0,0,0,130,0,76,0,226,0,0,0,232,0,241,0,246,0,0,0,184,0,100,0,73,0,64,0,0,0,0,0,44,0,72,0,252,0,246,0,111,0,141,0,207,0,0,0,81,0,82,0,0,0,64,0,127,0,8,0,0,0,87,0,65,0,91,0,20,0,112,0,214,0,39,0,0,0,0,0,0,0,228,0,0,0,60,0,91,0,99,0,70,0,39,0,0,0,220,0,0,0,231,0,73,0,0,0,192,0,233,0,137,0,137,0,163,0,0,0,180,0,0,0,8,0,194,0,211,0,54,0,235,0,189,0,145,0,17,0,129,0,82,0,52,0,128,0,248,0,6,0,92,0,138,0,57,0,0,0,111,0,41,0,0,0,38,0,0,0,35,0,238,0,0,0,0,0,168,0,45,0,248,0,95,0,131,0,210,0,39,0,127,0,201,0,0,0,69,0,0,0,0,0,0,0,30,0,0,0,85,0,218,0,178,0,56,0,92,0,109,0,157,0,0,0,129,0,27,0,246,0,0,0,225,0,225,0,76,0,111,0,169,0,60,0,26,0,207,0,0,0,222,0,28,0,230,0,101,0,139,0,0,0,58,0,246,0,133,0,125,0,21,0,20,0,0,0,18,0,2,0,91,0,220,0,197,0,84,0,7,0,41,0,34,0,181,0,83,0,63,0,207,0,147,0,66,0,0,0,248,0,95,0,118,0,65,0,42,0,186,0,93,0,0,0,23,0,0,0,0,0,8,0,238,0,0,0,228,0,0,0);
signal scenario_full  : scenario_type := (136,31,92,31,175,31,191,31,49,31,23,31,23,30,32,31,41,31,220,31,223,31,210,31,210,30,210,29,210,28,230,31,212,31,61,31,25,31,133,31,82,31,82,30,167,31,161,31,186,31,222,31,222,30,219,31,34,31,218,31,218,30,79,31,79,30,79,29,108,31,108,30,178,31,211,31,159,31,165,31,169,31,214,31,144,31,148,31,176,31,29,31,29,30,29,29,29,28,29,27,81,31,62,31,62,30,175,31,155,31,155,30,155,29,21,31,141,31,236,31,241,31,241,30,136,31,121,31,221,31,142,31,142,30,123,31,252,31,252,30,252,29,1,31,119,31,95,31,95,30,144,31,127,31,38,31,38,30,87,31,43,31,182,31,102,31,235,31,137,31,137,30,137,29,165,31,184,31,184,30,93,31,75,31,133,31,75,31,182,31,157,31,210,31,210,30,210,29,7,31,7,30,74,31,55,31,96,31,96,30,39,31,134,31,194,31,205,31,202,31,1,31,101,31,243,31,2,31,2,30,26,31,244,31,244,30,228,31,228,30,54,31,208,31,18,31,46,31,177,31,131,31,101,31,3,31,78,31,139,31,41,31,41,30,41,29,41,28,196,31,196,30,196,29,48,31,48,30,48,29,35,31,170,31,210,31,183,31,123,31,228,31,247,31,142,31,252,31,234,31,234,30,210,31,101,31,101,30,30,31,30,30,140,31,8,31,70,31,70,30,251,31,102,31,69,31,140,31,6,31,67,31,78,31,78,30,78,29,197,31,165,31,182,31,113,31,60,31,78,31,188,31,188,30,232,31,232,30,97,31,39,31,10,31,136,31,136,30,71,31,186,31,52,31,226,31,226,30,229,31,10,31,241,31,254,31,230,31,163,31,104,31,51,31,186,31,143,31,247,31,180,31,167,31,167,30,167,29,174,31,174,30,185,31,110,31,172,31,40,31,40,30,221,31,180,31,223,31,180,31,137,31,162,31,146,31,250,31,142,31,38,31,38,30,138,31,178,31,93,31,23,31,161,31,140,31,207,31,207,30,31,31,121,31,65,31,19,31,223,31,217,31,158,31,241,31,52,31,52,30,180,31,180,30,55,31,55,30,7,31,40,31,146,31,3,31,69,31,228,31,175,31,3,31,222,31,222,30,152,31,158,31,244,31,244,30,187,31,197,31,33,31,52,31,240,31,14,31,208,31,135,31,176,31,165,31,80,31,112,31,117,31,122,31,153,31,153,30,201,31,201,30,234,31,62,31,62,30,242,31,239,31,229,31,111,31,143,31,143,30,115,31,91,31,51,31,168,31,99,31,225,31,225,30,224,31,180,31,180,30,212,31,90,31,158,31,216,31,71,31,71,30,71,29,158,31,121,31,127,31,127,30,85,31,70,31,25,31,109,31,235,31,53,31,177,31,99,31,99,30,157,31,86,31,81,31,81,31,171,31,171,30,231,31,9,31,9,30,43,31,58,31,20,31,206,31,206,30,5,31,118,31,115,31,58,31,58,30,21,31,37,31,157,31,228,31,179,31,179,30,178,31,178,30,130,31,76,31,226,31,226,30,232,31,241,31,246,31,246,30,184,31,100,31,73,31,64,31,64,30,64,29,44,31,72,31,252,31,246,31,111,31,141,31,207,31,207,30,81,31,82,31,82,30,64,31,127,31,8,31,8,30,87,31,65,31,91,31,20,31,112,31,214,31,39,31,39,30,39,29,39,28,228,31,228,30,60,31,91,31,99,31,70,31,39,31,39,30,220,31,220,30,231,31,73,31,73,30,192,31,233,31,137,31,137,31,163,31,163,30,180,31,180,30,8,31,194,31,211,31,54,31,235,31,189,31,145,31,17,31,129,31,82,31,52,31,128,31,248,31,6,31,92,31,138,31,57,31,57,30,111,31,41,31,41,30,38,31,38,30,35,31,238,31,238,30,238,29,168,31,45,31,248,31,95,31,131,31,210,31,39,31,127,31,201,31,201,30,69,31,69,30,69,29,69,28,30,31,30,30,85,31,218,31,178,31,56,31,92,31,109,31,157,31,157,30,129,31,27,31,246,31,246,30,225,31,225,31,76,31,111,31,169,31,60,31,26,31,207,31,207,30,222,31,28,31,230,31,101,31,139,31,139,30,58,31,246,31,133,31,125,31,21,31,20,31,20,30,18,31,2,31,91,31,220,31,197,31,84,31,7,31,41,31,34,31,181,31,83,31,63,31,207,31,147,31,66,31,66,30,248,31,95,31,118,31,65,31,42,31,186,31,93,31,93,30,23,31,23,30,23,29,8,31,238,31,238,30,228,31,228,30);

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
