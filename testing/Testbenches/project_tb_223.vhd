-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_223 is
end project_tb_223;

architecture project_tb_arch_223 of project_tb_223 is
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

constant SCENARIO_LENGTH : integer := 420;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (1,0,0,0,31,0,234,0,244,0,90,0,0,0,58,0,168,0,24,0,248,0,152,0,0,0,0,0,54,0,251,0,127,0,212,0,19,0,159,0,90,0,175,0,145,0,127,0,101,0,76,0,36,0,101,0,183,0,28,0,174,0,40,0,0,0,0,0,82,0,157,0,29,0,109,0,0,0,35,0,19,0,217,0,140,0,52,0,158,0,0,0,96,0,178,0,143,0,124,0,86,0,0,0,215,0,0,0,6,0,3,0,106,0,199,0,172,0,122,0,19,0,14,0,0,0,175,0,29,0,185,0,25,0,0,0,20,0,0,0,127,0,0,0,109,0,205,0,137,0,81,0,246,0,21,0,0,0,155,0,13,0,60,0,127,0,167,0,0,0,214,0,0,0,39,0,194,0,54,0,90,0,140,0,158,0,15,0,17,0,0,0,0,0,220,0,0,0,221,0,40,0,0,0,113,0,45,0,184,0,25,0,0,0,14,0,0,0,117,0,200,0,12,0,116,0,0,0,210,0,122,0,0,0,26,0,184,0,13,0,143,0,201,0,207,0,189,0,202,0,203,0,182,0,30,0,19,0,212,0,0,0,75,0,214,0,187,0,44,0,2,0,3,0,206,0,167,0,0,0,109,0,198,0,172,0,79,0,123,0,158,0,112,0,0,0,221,0,159,0,182,0,110,0,97,0,170,0,129,0,193,0,100,0,145,0,68,0,0,0,192,0,0,0,122,0,214,0,173,0,168,0,184,0,30,0,224,0,147,0,28,0,114,0,0,0,0,0,0,0,202,0,0,0,86,0,114,0,143,0,0,0,0,0,0,0,15,0,11,0,161,0,208,0,0,0,228,0,140,0,168,0,38,0,32,0,228,0,177,0,84,0,135,0,213,0,13,0,187,0,5,0,0,0,170,0,153,0,0,0,53,0,27,0,104,0,30,0,86,0,0,0,27,0,40,0,170,0,102,0,72,0,92,0,17,0,23,0,209,0,0,0,46,0,126,0,123,0,139,0,161,0,233,0,130,0,148,0,158,0,180,0,89,0,231,0,0,0,219,0,0,0,0,0,0,0,248,0,23,0,100,0,126,0,0,0,0,0,82,0,30,0,0,0,177,0,185,0,91,0,200,0,200,0,0,0,0,0,84,0,0,0,1,0,137,0,149,0,176,0,219,0,89,0,59,0,239,0,162,0,67,0,105,0,36,0,0,0,252,0,176,0,215,0,157,0,92,0,58,0,0,0,168,0,0,0,0,0,70,0,208,0,140,0,196,0,16,0,37,0,0,0,234,0,145,0,0,0,176,0,184,0,210,0,79,0,0,0,229,0,59,0,65,0,94,0,0,0,160,0,137,0,84,0,100,0,67,0,118,0,216,0,56,0,118,0,183,0,158,0,99,0,104,0,144,0,235,0,239,0,224,0,41,0,10,0,234,0,158,0,157,0,231,0,246,0,0,0,101,0,146,0,0,0,0,0,0,0,77,0,0,0,150,0,44,0,229,0,29,0,239,0,72,0,0,0,72,0,113,0,216,0,160,0,247,0,0,0,76,0,77,0,17,0,183,0,120,0,94,0,0,0,81,0,0,0,26,0,151,0,77,0,0,0,242,0,165,0,39,0,86,0,112,0,223,0,232,0,191,0,0,0,114,0,175,0,0,0,98,0,0,0,145,0,152,0,147,0,248,0,156,0,176,0,213,0,242,0,205,0,0,0,221,0,0,0,156,0,23,0,252,0,230,0,0,0,108,0,129,0,0,0,205,0,67,0,0,0,197,0,251,0,0,0,213,0,82,0,11,0,94,0,80,0,70,0,64,0,149,0,125,0,98,0,194,0,213,0,177,0,26,0,0,0,123,0,145,0,37,0,46,0,31,0,255,0,182,0,125,0);
signal scenario_full  : scenario_type := (1,31,1,30,31,31,234,31,244,31,90,31,90,30,58,31,168,31,24,31,248,31,152,31,152,30,152,29,54,31,251,31,127,31,212,31,19,31,159,31,90,31,175,31,145,31,127,31,101,31,76,31,36,31,101,31,183,31,28,31,174,31,40,31,40,30,40,29,82,31,157,31,29,31,109,31,109,30,35,31,19,31,217,31,140,31,52,31,158,31,158,30,96,31,178,31,143,31,124,31,86,31,86,30,215,31,215,30,6,31,3,31,106,31,199,31,172,31,122,31,19,31,14,31,14,30,175,31,29,31,185,31,25,31,25,30,20,31,20,30,127,31,127,30,109,31,205,31,137,31,81,31,246,31,21,31,21,30,155,31,13,31,60,31,127,31,167,31,167,30,214,31,214,30,39,31,194,31,54,31,90,31,140,31,158,31,15,31,17,31,17,30,17,29,220,31,220,30,221,31,40,31,40,30,113,31,45,31,184,31,25,31,25,30,14,31,14,30,117,31,200,31,12,31,116,31,116,30,210,31,122,31,122,30,26,31,184,31,13,31,143,31,201,31,207,31,189,31,202,31,203,31,182,31,30,31,19,31,212,31,212,30,75,31,214,31,187,31,44,31,2,31,3,31,206,31,167,31,167,30,109,31,198,31,172,31,79,31,123,31,158,31,112,31,112,30,221,31,159,31,182,31,110,31,97,31,170,31,129,31,193,31,100,31,145,31,68,31,68,30,192,31,192,30,122,31,214,31,173,31,168,31,184,31,30,31,224,31,147,31,28,31,114,31,114,30,114,29,114,28,202,31,202,30,86,31,114,31,143,31,143,30,143,29,143,28,15,31,11,31,161,31,208,31,208,30,228,31,140,31,168,31,38,31,32,31,228,31,177,31,84,31,135,31,213,31,13,31,187,31,5,31,5,30,170,31,153,31,153,30,53,31,27,31,104,31,30,31,86,31,86,30,27,31,40,31,170,31,102,31,72,31,92,31,17,31,23,31,209,31,209,30,46,31,126,31,123,31,139,31,161,31,233,31,130,31,148,31,158,31,180,31,89,31,231,31,231,30,219,31,219,30,219,29,219,28,248,31,23,31,100,31,126,31,126,30,126,29,82,31,30,31,30,30,177,31,185,31,91,31,200,31,200,31,200,30,200,29,84,31,84,30,1,31,137,31,149,31,176,31,219,31,89,31,59,31,239,31,162,31,67,31,105,31,36,31,36,30,252,31,176,31,215,31,157,31,92,31,58,31,58,30,168,31,168,30,168,29,70,31,208,31,140,31,196,31,16,31,37,31,37,30,234,31,145,31,145,30,176,31,184,31,210,31,79,31,79,30,229,31,59,31,65,31,94,31,94,30,160,31,137,31,84,31,100,31,67,31,118,31,216,31,56,31,118,31,183,31,158,31,99,31,104,31,144,31,235,31,239,31,224,31,41,31,10,31,234,31,158,31,157,31,231,31,246,31,246,30,101,31,146,31,146,30,146,29,146,28,77,31,77,30,150,31,44,31,229,31,29,31,239,31,72,31,72,30,72,31,113,31,216,31,160,31,247,31,247,30,76,31,77,31,17,31,183,31,120,31,94,31,94,30,81,31,81,30,26,31,151,31,77,31,77,30,242,31,165,31,39,31,86,31,112,31,223,31,232,31,191,31,191,30,114,31,175,31,175,30,98,31,98,30,145,31,152,31,147,31,248,31,156,31,176,31,213,31,242,31,205,31,205,30,221,31,221,30,156,31,23,31,252,31,230,31,230,30,108,31,129,31,129,30,205,31,67,31,67,30,197,31,251,31,251,30,213,31,82,31,11,31,94,31,80,31,70,31,64,31,149,31,125,31,98,31,194,31,213,31,177,31,26,31,26,30,123,31,145,31,37,31,46,31,31,31,255,31,182,31,125,31);

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
