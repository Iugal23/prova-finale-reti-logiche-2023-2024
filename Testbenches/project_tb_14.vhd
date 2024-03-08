-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_14 is
end project_tb_14;

architecture project_tb_arch_14 of project_tb_14 is
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

constant SCENARIO_LENGTH : integer := 736;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (11,0,0,0,184,0,100,0,0,0,0,0,143,0,220,0,206,0,50,0,50,0,0,0,218,0,254,0,199,0,197,0,111,0,0,0,220,0,0,0,18,0,0,0,222,0,0,0,148,0,0,0,171,0,172,0,143,0,130,0,140,0,70,0,123,0,123,0,165,0,0,0,98,0,0,0,139,0,0,0,129,0,244,0,138,0,213,0,94,0,237,0,97,0,250,0,0,0,0,0,17,0,0,0,52,0,182,0,17,0,0,0,121,0,174,0,178,0,197,0,225,0,82,0,31,0,0,0,0,0,0,0,0,0,73,0,20,0,0,0,254,0,0,0,81,0,129,0,0,0,0,0,0,0,151,0,81,0,190,0,0,0,87,0,25,0,0,0,71,0,75,0,101,0,127,0,114,0,28,0,13,0,94,0,119,0,24,0,44,0,23,0,0,0,183,0,114,0,187,0,212,0,1,0,18,0,246,0,147,0,62,0,35,0,137,0,21,0,109,0,50,0,238,0,244,0,154,0,0,0,0,0,223,0,0,0,0,0,195,0,146,0,136,0,57,0,154,0,217,0,192,0,214,0,51,0,1,0,155,0,201,0,185,0,3,0,174,0,223,0,0,0,137,0,117,0,0,0,217,0,193,0,171,0,245,0,10,0,75,0,0,0,0,0,5,0,147,0,9,0,119,0,196,0,149,0,23,0,58,0,146,0,0,0,0,0,106,0,21,0,250,0,135,0,0,0,228,0,144,0,151,0,174,0,246,0,58,0,0,0,70,0,125,0,172,0,0,0,82,0,106,0,76,0,197,0,0,0,2,0,86,0,120,0,220,0,35,0,202,0,154,0,53,0,47,0,72,0,198,0,180,0,181,0,0,0,0,0,19,0,125,0,87,0,184,0,122,0,69,0,248,0,60,0,219,0,179,0,183,0,230,0,199,0,12,0,126,0,46,0,183,0,121,0,0,0,200,0,71,0,26,0,0,0,0,0,120,0,121,0,183,0,147,0,192,0,0,0,0,0,230,0,0,0,101,0,131,0,249,0,133,0,64,0,231,0,63,0,0,0,188,0,54,0,60,0,226,0,27,0,0,0,158,0,175,0,67,0,105,0,86,0,243,0,157,0,178,0,202,0,0,0,0,0,0,0,177,0,0,0,0,0,250,0,0,0,88,0,110,0,52,0,20,0,222,0,0,0,199,0,240,0,22,0,21,0,228,0,222,0,116,0,121,0,197,0,16,0,99,0,51,0,20,0,97,0,183,0,0,0,209,0,148,0,104,0,124,0,0,0,223,0,171,0,82,0,130,0,103,0,163,0,247,0,0,0,56,0,74,0,149,0,91,0,18,0,161,0,91,0,139,0,27,0,75,0,123,0,221,0,175,0,165,0,113,0,167,0,93,0,237,0,233,0,0,0,4,0,255,0,44,0,98,0,156,0,102,0,70,0,0,0,46,0,202,0,248,0,30,0,51,0,0,0,114,0,0,0,224,0,226,0,24,0,238,0,52,0,87,0,54,0,225,0,223,0,72,0,89,0,62,0,146,0,131,0,119,0,227,0,14,0,104,0,0,0,0,0,13,0,44,0,176,0,70,0,30,0,76,0,205,0,43,0,0,0,0,0,2,0,191,0,61,0,136,0,250,0,108,0,202,0,0,0,179,0,0,0,248,0,22,0,0,0,58,0,0,0,236,0,131,0,239,0,254,0,68,0,19,0,81,0,0,0,137,0,143,0,78,0,219,0,215,0,109,0,0,0,120,0,0,0,148,0,0,0,23,0,37,0,91,0,125,0,86,0,16,0,173,0,141,0,0,0,37,0,81,0,194,0,155,0,228,0,0,0,103,0,200,0,0,0,0,0,134,0,242,0,0,0,203,0,9,0,0,0,0,0,73,0,0,0,0,0,0,0,58,0,0,0,200,0,68,0,222,0,0,0,123,0,155,0,247,0,120,0,211,0,206,0,15,0,220,0,58,0,150,0,141,0,0,0,104,0,219,0,86,0,84,0,0,0,250,0,147,0,0,0,119,0,161,0,120,0,91,0,86,0,17,0,0,0,65,0,0,0,72,0,120,0,12,0,0,0,57,0,217,0,118,0,240,0,216,0,180,0,85,0,32,0,101,0,0,0,183,0,247,0,148,0,74,0,161,0,123,0,57,0,132,0,0,0,37,0,0,0,27,0,179,0,50,0,0,0,243,0,153,0,218,0,149,0,108,0,10,0,115,0,198,0,124,0,12,0,210,0,58,0,37,0,82,0,123,0,155,0,181,0,251,0,103,0,211,0,197,0,96,0,28,0,47,0,98,0,237,0,0,0,51,0,250,0,0,0,65,0,148,0,101,0,255,0,244,0,182,0,91,0,133,0,29,0,110,0,219,0,51,0,0,0,0,0,98,0,38,0,151,0,0,0,129,0,133,0,180,0,232,0,176,0,170,0,0,0,48,0,187,0,159,0,38,0,192,0,0,0,163,0,0,0,42,0,29,0,166,0,0,0,0,0,205,0,80,0,89,0,41,0,250,0,0,0,10,0,141,0,0,0,0,0,0,0,2,0,145,0,49,0,83,0,223,0,25,0,71,0,0,0,169,0,0,0,0,0,224,0,0,0,248,0,52,0,243,0,200,0,201,0,0,0,99,0,149,0,89,0,15,0,64,0,155,0,0,0,143,0,173,0,46,0,85,0,189,0,62,0,196,0,0,0,0,0,73,0,0,0,17,0,162,0,83,0,118,0,184,0,174,0,68,0,0,0,58,0,68,0,38,0,0,0,131,0,10,0,252,0,80,0,14,0,0,0,114,0,72,0,0,0,0,0,223,0,0,0,48,0,132,0,0,0,159,0,135,0,243,0,184,0,102,0,150,0,0,0,164,0,11,0,0,0,137,0,207,0,97,0,154,0,220,0,115,0,59,0,0,0,190,0,0,0,209,0,45,0,9,0,55,0,0,0,206,0,131,0,116,0,174,0,32,0,0,0,18,0,0,0,118,0,196,0,147,0,212,0,17,0,242,0,208,0,78,0,20,0,102,0,58,0,152,0,203,0,109,0,11,0,85,0,52,0,93,0,23,0,0,0,56,0,104,0,88,0,198,0,207,0,0,0,131,0,224,0,0,0,240,0,148,0,0,0,198,0,141,0,48,0,35,0,231,0,0,0,128,0,106,0,135,0,243,0,31,0,202,0,213,0,178,0,159,0,26,0,0,0,94,0,164,0,140,0,102,0,17,0,8,0,176,0,160,0,101,0,138,0,142,0,139,0,233,0,217,0,3,0,79,0,66,0,216,0,9,0,159,0,149,0,14,0,14,0,6,0);
signal scenario_full  : scenario_type := (11,31,11,30,184,31,100,31,100,30,100,29,143,31,220,31,206,31,50,31,50,31,50,30,218,31,254,31,199,31,197,31,111,31,111,30,220,31,220,30,18,31,18,30,222,31,222,30,148,31,148,30,171,31,172,31,143,31,130,31,140,31,70,31,123,31,123,31,165,31,165,30,98,31,98,30,139,31,139,30,129,31,244,31,138,31,213,31,94,31,237,31,97,31,250,31,250,30,250,29,17,31,17,30,52,31,182,31,17,31,17,30,121,31,174,31,178,31,197,31,225,31,82,31,31,31,31,30,31,29,31,28,31,27,73,31,20,31,20,30,254,31,254,30,81,31,129,31,129,30,129,29,129,28,151,31,81,31,190,31,190,30,87,31,25,31,25,30,71,31,75,31,101,31,127,31,114,31,28,31,13,31,94,31,119,31,24,31,44,31,23,31,23,30,183,31,114,31,187,31,212,31,1,31,18,31,246,31,147,31,62,31,35,31,137,31,21,31,109,31,50,31,238,31,244,31,154,31,154,30,154,29,223,31,223,30,223,29,195,31,146,31,136,31,57,31,154,31,217,31,192,31,214,31,51,31,1,31,155,31,201,31,185,31,3,31,174,31,223,31,223,30,137,31,117,31,117,30,217,31,193,31,171,31,245,31,10,31,75,31,75,30,75,29,5,31,147,31,9,31,119,31,196,31,149,31,23,31,58,31,146,31,146,30,146,29,106,31,21,31,250,31,135,31,135,30,228,31,144,31,151,31,174,31,246,31,58,31,58,30,70,31,125,31,172,31,172,30,82,31,106,31,76,31,197,31,197,30,2,31,86,31,120,31,220,31,35,31,202,31,154,31,53,31,47,31,72,31,198,31,180,31,181,31,181,30,181,29,19,31,125,31,87,31,184,31,122,31,69,31,248,31,60,31,219,31,179,31,183,31,230,31,199,31,12,31,126,31,46,31,183,31,121,31,121,30,200,31,71,31,26,31,26,30,26,29,120,31,121,31,183,31,147,31,192,31,192,30,192,29,230,31,230,30,101,31,131,31,249,31,133,31,64,31,231,31,63,31,63,30,188,31,54,31,60,31,226,31,27,31,27,30,158,31,175,31,67,31,105,31,86,31,243,31,157,31,178,31,202,31,202,30,202,29,202,28,177,31,177,30,177,29,250,31,250,30,88,31,110,31,52,31,20,31,222,31,222,30,199,31,240,31,22,31,21,31,228,31,222,31,116,31,121,31,197,31,16,31,99,31,51,31,20,31,97,31,183,31,183,30,209,31,148,31,104,31,124,31,124,30,223,31,171,31,82,31,130,31,103,31,163,31,247,31,247,30,56,31,74,31,149,31,91,31,18,31,161,31,91,31,139,31,27,31,75,31,123,31,221,31,175,31,165,31,113,31,167,31,93,31,237,31,233,31,233,30,4,31,255,31,44,31,98,31,156,31,102,31,70,31,70,30,46,31,202,31,248,31,30,31,51,31,51,30,114,31,114,30,224,31,226,31,24,31,238,31,52,31,87,31,54,31,225,31,223,31,72,31,89,31,62,31,146,31,131,31,119,31,227,31,14,31,104,31,104,30,104,29,13,31,44,31,176,31,70,31,30,31,76,31,205,31,43,31,43,30,43,29,2,31,191,31,61,31,136,31,250,31,108,31,202,31,202,30,179,31,179,30,248,31,22,31,22,30,58,31,58,30,236,31,131,31,239,31,254,31,68,31,19,31,81,31,81,30,137,31,143,31,78,31,219,31,215,31,109,31,109,30,120,31,120,30,148,31,148,30,23,31,37,31,91,31,125,31,86,31,16,31,173,31,141,31,141,30,37,31,81,31,194,31,155,31,228,31,228,30,103,31,200,31,200,30,200,29,134,31,242,31,242,30,203,31,9,31,9,30,9,29,73,31,73,30,73,29,73,28,58,31,58,30,200,31,68,31,222,31,222,30,123,31,155,31,247,31,120,31,211,31,206,31,15,31,220,31,58,31,150,31,141,31,141,30,104,31,219,31,86,31,84,31,84,30,250,31,147,31,147,30,119,31,161,31,120,31,91,31,86,31,17,31,17,30,65,31,65,30,72,31,120,31,12,31,12,30,57,31,217,31,118,31,240,31,216,31,180,31,85,31,32,31,101,31,101,30,183,31,247,31,148,31,74,31,161,31,123,31,57,31,132,31,132,30,37,31,37,30,27,31,179,31,50,31,50,30,243,31,153,31,218,31,149,31,108,31,10,31,115,31,198,31,124,31,12,31,210,31,58,31,37,31,82,31,123,31,155,31,181,31,251,31,103,31,211,31,197,31,96,31,28,31,47,31,98,31,237,31,237,30,51,31,250,31,250,30,65,31,148,31,101,31,255,31,244,31,182,31,91,31,133,31,29,31,110,31,219,31,51,31,51,30,51,29,98,31,38,31,151,31,151,30,129,31,133,31,180,31,232,31,176,31,170,31,170,30,48,31,187,31,159,31,38,31,192,31,192,30,163,31,163,30,42,31,29,31,166,31,166,30,166,29,205,31,80,31,89,31,41,31,250,31,250,30,10,31,141,31,141,30,141,29,141,28,2,31,145,31,49,31,83,31,223,31,25,31,71,31,71,30,169,31,169,30,169,29,224,31,224,30,248,31,52,31,243,31,200,31,201,31,201,30,99,31,149,31,89,31,15,31,64,31,155,31,155,30,143,31,173,31,46,31,85,31,189,31,62,31,196,31,196,30,196,29,73,31,73,30,17,31,162,31,83,31,118,31,184,31,174,31,68,31,68,30,58,31,68,31,38,31,38,30,131,31,10,31,252,31,80,31,14,31,14,30,114,31,72,31,72,30,72,29,223,31,223,30,48,31,132,31,132,30,159,31,135,31,243,31,184,31,102,31,150,31,150,30,164,31,11,31,11,30,137,31,207,31,97,31,154,31,220,31,115,31,59,31,59,30,190,31,190,30,209,31,45,31,9,31,55,31,55,30,206,31,131,31,116,31,174,31,32,31,32,30,18,31,18,30,118,31,196,31,147,31,212,31,17,31,242,31,208,31,78,31,20,31,102,31,58,31,152,31,203,31,109,31,11,31,85,31,52,31,93,31,23,31,23,30,56,31,104,31,88,31,198,31,207,31,207,30,131,31,224,31,224,30,240,31,148,31,148,30,198,31,141,31,48,31,35,31,231,31,231,30,128,31,106,31,135,31,243,31,31,31,202,31,213,31,178,31,159,31,26,31,26,30,94,31,164,31,140,31,102,31,17,31,8,31,176,31,160,31,101,31,138,31,142,31,139,31,233,31,217,31,3,31,79,31,66,31,216,31,9,31,159,31,149,31,14,31,14,31,6,31);

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
