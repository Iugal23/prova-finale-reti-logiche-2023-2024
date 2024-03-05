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

constant SCENARIO_LENGTH : integer := 583;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,16,0,116,0,94,0,106,0,144,0,215,0,187,0,0,0,0,0,219,0,0,0,132,0,147,0,0,0,20,0,34,0,0,0,84,0,177,0,64,0,0,0,108,0,0,0,46,0,222,0,192,0,248,0,0,0,0,0,37,0,110,0,109,0,0,0,13,0,7,0,200,0,154,0,132,0,233,0,132,0,148,0,0,0,19,0,218,0,31,0,0,0,41,0,136,0,76,0,2,0,200,0,235,0,26,0,203,0,21,0,237,0,0,0,235,0,201,0,60,0,148,0,34,0,3,0,7,0,39,0,240,0,52,0,20,0,0,0,119,0,50,0,179,0,67,0,211,0,79,0,116,0,0,0,215,0,0,0,0,0,109,0,116,0,59,0,242,0,218,0,0,0,75,0,51,0,220,0,62,0,218,0,198,0,125,0,67,0,0,0,38,0,54,0,0,0,0,0,137,0,234,0,112,0,200,0,13,0,133,0,137,0,54,0,243,0,35,0,32,0,127,0,189,0,116,0,226,0,19,0,16,0,73,0,0,0,119,0,162,0,31,0,235,0,26,0,80,0,14,0,197,0,250,0,0,0,143,0,94,0,41,0,0,0,185,0,71,0,172,0,114,0,228,0,247,0,122,0,28,0,118,0,82,0,175,0,163,0,0,0,94,0,53,0,0,0,0,0,99,0,212,0,160,0,231,0,236,0,116,0,204,0,0,0,176,0,82,0,5,0,136,0,0,0,170,0,0,0,0,0,68,0,20,0,0,0,84,0,129,0,0,0,182,0,144,0,135,0,0,0,0,0,115,0,62,0,0,0,180,0,152,0,40,0,29,0,0,0,183,0,13,0,82,0,191,0,35,0,173,0,9,0,84,0,0,0,32,0,201,0,0,0,112,0,93,0,205,0,196,0,0,0,115,0,117,0,0,0,97,0,91,0,105,0,231,0,45,0,149,0,86,0,175,0,254,0,208,0,0,0,186,0,0,0,229,0,16,0,214,0,0,0,120,0,0,0,191,0,135,0,232,0,198,0,105,0,6,0,54,0,81,0,0,0,0,0,0,0,171,0,93,0,211,0,0,0,235,0,219,0,27,0,196,0,0,0,46,0,0,0,120,0,159,0,34,0,0,0,247,0,0,0,168,0,0,0,109,0,79,0,0,0,224,0,0,0,41,0,148,0,9,0,77,0,139,0,223,0,105,0,0,0,109,0,92,0,24,0,167,0,101,0,154,0,205,0,0,0,214,0,189,0,212,0,32,0,0,0,61,0,0,0,0,0,0,0,232,0,187,0,5,0,0,0,118,0,0,0,123,0,164,0,60,0,2,0,64,0,208,0,220,0,86,0,143,0,0,0,40,0,37,0,225,0,0,0,136,0,61,0,83,0,0,0,111,0,184,0,115,0,0,0,143,0,178,0,228,0,240,0,226,0,0,0,165,0,69,0,178,0,49,0,84,0,225,0,74,0,0,0,128,0,194,0,151,0,224,0,166,0,79,0,72,0,21,0,24,0,214,0,0,0,233,0,0,0,223,0,0,0,230,0,134,0,0,0,211,0,150,0,56,0,0,0,243,0,0,0,75,0,90,0,0,0,0,0,112,0,47,0,201,0,0,0,238,0,221,0,250,0,134,0,0,0,44,0,0,0,99,0,170,0,251,0,36,0,26,0,0,0,197,0,98,0,64,0,178,0,0,0,162,0,86,0,129,0,234,0,210,0,114,0,0,0,0,0,0,0,103,0,62,0,87,0,196,0,226,0,53,0,62,0,213,0,183,0,0,0,41,0,140,0,177,0,183,0,114,0,81,0,132,0,217,0,127,0,121,0,158,0,210,0,166,0,107,0,0,0,70,0,155,0,0,0,75,0,136,0,0,0,70,0,213,0,104,0,105,0,163,0,159,0,171,0,152,0,167,0,161,0,193,0,219,0,0,0,112,0,163,0,80,0,0,0,121,0,126,0,11,0,130,0,4,0,195,0,152,0,146,0,0,0,30,0,0,0,0,0,28,0,190,0,112,0,120,0,232,0,80,0,0,0,203,0,169,0,209,0,141,0,102,0,0,0,63,0,7,0,228,0,57,0,43,0,178,0,0,0,37,0,240,0,129,0,113,0,74,0,117,0,0,0,237,0,201,0,0,0,101,0,11,0,126,0,239,0,111,0,208,0,0,0,95,0,164,0,153,0,123,0,200,0,17,0,0,0,159,0,233,0,131,0,0,0,74,0,119,0,0,0,197,0,0,0,0,0,106,0,136,0,241,0,49,0,25,0,194,0,38,0,226,0,195,0,214,0,0,0,39,0,227,0,244,0,21,0,37,0,159,0,87,0,233,0,224,0,184,0,203,0,205,0,120,0,199,0,153,0,153,0,156,0,174,0,230,0,0,0,0,0,194,0,170,0,192,0,124,0,0,0,240,0,73,0,168,0,61,0,0,0,120,0,72,0,185,0,89,0,231,0,219,0,0,0,176,0,166,0,85,0,66,0,85,0,0,0,29,0,74,0,3,0,130,0,250,0,173,0,0,0,184,0,18,0,134,0,211,0,27,0,0,0,32,0,103,0,240,0,0,0,21,0,0,0,197,0,217,0,77,0,194,0,25,0,128,0,124,0,73,0,180,0,191,0);
signal scenario_full  : scenario_type := (0,0,16,31,116,31,94,31,106,31,144,31,215,31,187,31,187,30,187,29,219,31,219,30,132,31,147,31,147,30,20,31,34,31,34,30,84,31,177,31,64,31,64,30,108,31,108,30,46,31,222,31,192,31,248,31,248,30,248,29,37,31,110,31,109,31,109,30,13,31,7,31,200,31,154,31,132,31,233,31,132,31,148,31,148,30,19,31,218,31,31,31,31,30,41,31,136,31,76,31,2,31,200,31,235,31,26,31,203,31,21,31,237,31,237,30,235,31,201,31,60,31,148,31,34,31,3,31,7,31,39,31,240,31,52,31,20,31,20,30,119,31,50,31,179,31,67,31,211,31,79,31,116,31,116,30,215,31,215,30,215,29,109,31,116,31,59,31,242,31,218,31,218,30,75,31,51,31,220,31,62,31,218,31,198,31,125,31,67,31,67,30,38,31,54,31,54,30,54,29,137,31,234,31,112,31,200,31,13,31,133,31,137,31,54,31,243,31,35,31,32,31,127,31,189,31,116,31,226,31,19,31,16,31,73,31,73,30,119,31,162,31,31,31,235,31,26,31,80,31,14,31,197,31,250,31,250,30,143,31,94,31,41,31,41,30,185,31,71,31,172,31,114,31,228,31,247,31,122,31,28,31,118,31,82,31,175,31,163,31,163,30,94,31,53,31,53,30,53,29,99,31,212,31,160,31,231,31,236,31,116,31,204,31,204,30,176,31,82,31,5,31,136,31,136,30,170,31,170,30,170,29,68,31,20,31,20,30,84,31,129,31,129,30,182,31,144,31,135,31,135,30,135,29,115,31,62,31,62,30,180,31,152,31,40,31,29,31,29,30,183,31,13,31,82,31,191,31,35,31,173,31,9,31,84,31,84,30,32,31,201,31,201,30,112,31,93,31,205,31,196,31,196,30,115,31,117,31,117,30,97,31,91,31,105,31,231,31,45,31,149,31,86,31,175,31,254,31,208,31,208,30,186,31,186,30,229,31,16,31,214,31,214,30,120,31,120,30,191,31,135,31,232,31,198,31,105,31,6,31,54,31,81,31,81,30,81,29,81,28,171,31,93,31,211,31,211,30,235,31,219,31,27,31,196,31,196,30,46,31,46,30,120,31,159,31,34,31,34,30,247,31,247,30,168,31,168,30,109,31,79,31,79,30,224,31,224,30,41,31,148,31,9,31,77,31,139,31,223,31,105,31,105,30,109,31,92,31,24,31,167,31,101,31,154,31,205,31,205,30,214,31,189,31,212,31,32,31,32,30,61,31,61,30,61,29,61,28,232,31,187,31,5,31,5,30,118,31,118,30,123,31,164,31,60,31,2,31,64,31,208,31,220,31,86,31,143,31,143,30,40,31,37,31,225,31,225,30,136,31,61,31,83,31,83,30,111,31,184,31,115,31,115,30,143,31,178,31,228,31,240,31,226,31,226,30,165,31,69,31,178,31,49,31,84,31,225,31,74,31,74,30,128,31,194,31,151,31,224,31,166,31,79,31,72,31,21,31,24,31,214,31,214,30,233,31,233,30,223,31,223,30,230,31,134,31,134,30,211,31,150,31,56,31,56,30,243,31,243,30,75,31,90,31,90,30,90,29,112,31,47,31,201,31,201,30,238,31,221,31,250,31,134,31,134,30,44,31,44,30,99,31,170,31,251,31,36,31,26,31,26,30,197,31,98,31,64,31,178,31,178,30,162,31,86,31,129,31,234,31,210,31,114,31,114,30,114,29,114,28,103,31,62,31,87,31,196,31,226,31,53,31,62,31,213,31,183,31,183,30,41,31,140,31,177,31,183,31,114,31,81,31,132,31,217,31,127,31,121,31,158,31,210,31,166,31,107,31,107,30,70,31,155,31,155,30,75,31,136,31,136,30,70,31,213,31,104,31,105,31,163,31,159,31,171,31,152,31,167,31,161,31,193,31,219,31,219,30,112,31,163,31,80,31,80,30,121,31,126,31,11,31,130,31,4,31,195,31,152,31,146,31,146,30,30,31,30,30,30,29,28,31,190,31,112,31,120,31,232,31,80,31,80,30,203,31,169,31,209,31,141,31,102,31,102,30,63,31,7,31,228,31,57,31,43,31,178,31,178,30,37,31,240,31,129,31,113,31,74,31,117,31,117,30,237,31,201,31,201,30,101,31,11,31,126,31,239,31,111,31,208,31,208,30,95,31,164,31,153,31,123,31,200,31,17,31,17,30,159,31,233,31,131,31,131,30,74,31,119,31,119,30,197,31,197,30,197,29,106,31,136,31,241,31,49,31,25,31,194,31,38,31,226,31,195,31,214,31,214,30,39,31,227,31,244,31,21,31,37,31,159,31,87,31,233,31,224,31,184,31,203,31,205,31,120,31,199,31,153,31,153,31,156,31,174,31,230,31,230,30,230,29,194,31,170,31,192,31,124,31,124,30,240,31,73,31,168,31,61,31,61,30,120,31,72,31,185,31,89,31,231,31,219,31,219,30,176,31,166,31,85,31,66,31,85,31,85,30,29,31,74,31,3,31,130,31,250,31,173,31,173,30,184,31,18,31,134,31,211,31,27,31,27,30,32,31,103,31,240,31,240,30,21,31,21,30,197,31,217,31,77,31,194,31,25,31,128,31,124,31,73,31,180,31,191,31);

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
