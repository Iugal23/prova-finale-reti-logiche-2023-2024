-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_921 is
end project_tb_921;

architecture project_tb_arch_921 of project_tb_921 is
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

constant SCENARIO_LENGTH : integer := 712;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (125,0,0,0,21,0,218,0,231,0,0,0,92,0,119,0,159,0,196,0,42,0,136,0,244,0,60,0,0,0,141,0,146,0,179,0,151,0,32,0,129,0,148,0,47,0,0,0,0,0,0,0,217,0,54,0,242,0,227,0,147,0,148,0,209,0,0,0,163,0,141,0,246,0,49,0,146,0,255,0,137,0,0,0,248,0,211,0,0,0,163,0,32,0,146,0,198,0,77,0,29,0,0,0,169,0,181,0,86,0,60,0,0,0,234,0,174,0,26,0,68,0,47,0,0,0,224,0,179,0,41,0,146,0,189,0,0,0,102,0,52,0,21,0,242,0,109,0,212,0,0,0,234,0,236,0,83,0,109,0,178,0,0,0,117,0,105,0,7,0,0,0,0,0,92,0,138,0,0,0,183,0,131,0,64,0,86,0,59,0,46,0,97,0,9,0,107,0,0,0,194,0,66,0,35,0,134,0,46,0,253,0,196,0,254,0,0,0,162,0,141,0,168,0,172,0,102,0,0,0,47,0,159,0,192,0,82,0,209,0,248,0,147,0,30,0,0,0,0,0,140,0,0,0,193,0,226,0,0,0,61,0,145,0,92,0,67,0,59,0,163,0,68,0,24,0,198,0,113,0,0,0,4,0,248,0,123,0,0,0,32,0,61,0,0,0,118,0,215,0,5,0,28,0,201,0,161,0,124,0,0,0,70,0,162,0,0,0,0,0,220,0,0,0,35,0,0,0,0,0,26,0,229,0,83,0,239,0,0,0,0,0,52,0,74,0,88,0,222,0,116,0,210,0,26,0,119,0,216,0,197,0,167,0,84,0,239,0,243,0,0,0,204,0,69,0,140,0,108,0,132,0,239,0,21,0,75,0,156,0,88,0,91,0,0,0,208,0,80,0,0,0,7,0,161,0,73,0,233,0,0,0,27,0,0,0,22,0,185,0,146,0,26,0,89,0,251,0,16,0,148,0,213,0,252,0,10,0,239,0,89,0,44,0,143,0,178,0,126,0,23,0,68,0,0,0,65,0,147,0,211,0,223,0,37,0,0,0,162,0,206,0,53,0,0,0,0,0,72,0,133,0,149,0,128,0,63,0,195,0,0,0,35,0,0,0,0,0,247,0,0,0,0,0,104,0,0,0,251,0,7,0,25,0,0,0,17,0,229,0,45,0,62,0,254,0,0,0,139,0,170,0,71,0,103,0,118,0,136,0,212,0,81,0,0,0,238,0,0,0,247,0,11,0,64,0,72,0,0,0,237,0,0,0,0,0,132,0,0,0,189,0,51,0,2,0,59,0,0,0,113,0,233,0,45,0,111,0,0,0,33,0,67,0,235,0,0,0,255,0,118,0,90,0,0,0,0,0,225,0,0,0,169,0,0,0,0,0,50,0,162,0,119,0,235,0,108,0,59,0,150,0,0,0,201,0,224,0,14,0,17,0,36,0,75,0,0,0,170,0,232,0,65,0,163,0,96,0,219,0,206,0,177,0,33,0,188,0,23,0,110,0,141,0,70,0,121,0,30,0,110,0,194,0,0,0,130,0,226,0,138,0,114,0,198,0,218,0,0,0,208,0,25,0,179,0,181,0,0,0,122,0,253,0,160,0,249,0,22,0,164,0,174,0,0,0,72,0,94,0,64,0,0,0,227,0,204,0,41,0,0,0,166,0,254,0,237,0,8,0,170,0,141,0,183,0,208,0,56,0,8,0,79,0,73,0,229,0,224,0,160,0,53,0,95,0,183,0,29,0,0,0,213,0,218,0,167,0,0,0,168,0,0,0,0,0,202,0,110,0,173,0,0,0,165,0,60,0,0,0,61,0,176,0,145,0,0,0,67,0,0,0,68,0,175,0,61,0,106,0,0,0,169,0,184,0,117,0,0,0,66,0,129,0,112,0,72,0,62,0,231,0,13,0,0,0,30,0,120,0,124,0,165,0,227,0,47,0,107,0,155,0,41,0,71,0,0,0,51,0,132,0,0,0,113,0,11,0,101,0,83,0,0,0,0,0,242,0,255,0,0,0,0,0,237,0,184,0,93,0,232,0,45,0,0,0,0,0,56,0,0,0,253,0,44,0,235,0,18,0,0,0,137,0,225,0,0,0,126,0,31,0,59,0,61,0,184,0,0,0,183,0,0,0,58,0,28,0,57,0,0,0,57,0,94,0,0,0,200,0,120,0,150,0,221,0,102,0,192,0,40,0,17,0,250,0,174,0,47,0,0,0,0,0,192,0,23,0,30,0,0,0,186,0,48,0,217,0,25,0,0,0,80,0,246,0,0,0,18,0,12,0,57,0,220,0,22,0,0,0,119,0,100,0,254,0,0,0,0,0,223,0,175,0,0,0,2,0,72,0,0,0,167,0,105,0,223,0,139,0,143,0,158,0,59,0,0,0,103,0,126,0,183,0,223,0,51,0,74,0,0,0,102,0,0,0,173,0,213,0,0,0,225,0,42,0,82,0,177,0,31,0,246,0,179,0,102,0,62,0,73,0,83,0,101,0,0,0,125,0,153,0,235,0,64,0,218,0,66,0,146,0,0,0,46,0,79,0,15,0,0,0,132,0,127,0,0,0,168,0,42,0,112,0,205,0,226,0,117,0,72,0,240,0,229,0,157,0,84,0,114,0,203,0,0,0,206,0,16,0,174,0,148,0,118,0,132,0,58,0,78,0,0,0,82,0,234,0,119,0,97,0,0,0,239,0,40,0,255,0,32,0,250,0,179,0,144,0,45,0,7,0,218,0,81,0,141,0,220,0,214,0,203,0,138,0,0,0,136,0,125,0,121,0,0,0,104,0,0,0,255,0,181,0,180,0,20,0,0,0,0,0,3,0,2,0,209,0,249,0,0,0,254,0,0,0,55,0,0,0,21,0,0,0,83,0,252,0,249,0,110,0,229,0,128,0,112,0,28,0,182,0,0,0,248,0,64,0,28,0,18,0,93,0,51,0,0,0,213,0,0,0,173,0,99,0,138,0,127,0,215,0,20,0,54,0,199,0,72,0,190,0,95,0,142,0,0,0,36,0,30,0,3,0,1,0,15,0,32,0,6,0,0,0,91,0,104,0,199,0,135,0,57,0,42,0,35,0,227,0,83,0,7,0,6,0,0,0,55,0,209,0,77,0,31,0,0,0,164,0,28,0,61,0,7,0,84,0,180,0,199,0,46,0,0,0,0,0,55,0,0,0,224,0);
signal scenario_full  : scenario_type := (125,31,125,30,21,31,218,31,231,31,231,30,92,31,119,31,159,31,196,31,42,31,136,31,244,31,60,31,60,30,141,31,146,31,179,31,151,31,32,31,129,31,148,31,47,31,47,30,47,29,47,28,217,31,54,31,242,31,227,31,147,31,148,31,209,31,209,30,163,31,141,31,246,31,49,31,146,31,255,31,137,31,137,30,248,31,211,31,211,30,163,31,32,31,146,31,198,31,77,31,29,31,29,30,169,31,181,31,86,31,60,31,60,30,234,31,174,31,26,31,68,31,47,31,47,30,224,31,179,31,41,31,146,31,189,31,189,30,102,31,52,31,21,31,242,31,109,31,212,31,212,30,234,31,236,31,83,31,109,31,178,31,178,30,117,31,105,31,7,31,7,30,7,29,92,31,138,31,138,30,183,31,131,31,64,31,86,31,59,31,46,31,97,31,9,31,107,31,107,30,194,31,66,31,35,31,134,31,46,31,253,31,196,31,254,31,254,30,162,31,141,31,168,31,172,31,102,31,102,30,47,31,159,31,192,31,82,31,209,31,248,31,147,31,30,31,30,30,30,29,140,31,140,30,193,31,226,31,226,30,61,31,145,31,92,31,67,31,59,31,163,31,68,31,24,31,198,31,113,31,113,30,4,31,248,31,123,31,123,30,32,31,61,31,61,30,118,31,215,31,5,31,28,31,201,31,161,31,124,31,124,30,70,31,162,31,162,30,162,29,220,31,220,30,35,31,35,30,35,29,26,31,229,31,83,31,239,31,239,30,239,29,52,31,74,31,88,31,222,31,116,31,210,31,26,31,119,31,216,31,197,31,167,31,84,31,239,31,243,31,243,30,204,31,69,31,140,31,108,31,132,31,239,31,21,31,75,31,156,31,88,31,91,31,91,30,208,31,80,31,80,30,7,31,161,31,73,31,233,31,233,30,27,31,27,30,22,31,185,31,146,31,26,31,89,31,251,31,16,31,148,31,213,31,252,31,10,31,239,31,89,31,44,31,143,31,178,31,126,31,23,31,68,31,68,30,65,31,147,31,211,31,223,31,37,31,37,30,162,31,206,31,53,31,53,30,53,29,72,31,133,31,149,31,128,31,63,31,195,31,195,30,35,31,35,30,35,29,247,31,247,30,247,29,104,31,104,30,251,31,7,31,25,31,25,30,17,31,229,31,45,31,62,31,254,31,254,30,139,31,170,31,71,31,103,31,118,31,136,31,212,31,81,31,81,30,238,31,238,30,247,31,11,31,64,31,72,31,72,30,237,31,237,30,237,29,132,31,132,30,189,31,51,31,2,31,59,31,59,30,113,31,233,31,45,31,111,31,111,30,33,31,67,31,235,31,235,30,255,31,118,31,90,31,90,30,90,29,225,31,225,30,169,31,169,30,169,29,50,31,162,31,119,31,235,31,108,31,59,31,150,31,150,30,201,31,224,31,14,31,17,31,36,31,75,31,75,30,170,31,232,31,65,31,163,31,96,31,219,31,206,31,177,31,33,31,188,31,23,31,110,31,141,31,70,31,121,31,30,31,110,31,194,31,194,30,130,31,226,31,138,31,114,31,198,31,218,31,218,30,208,31,25,31,179,31,181,31,181,30,122,31,253,31,160,31,249,31,22,31,164,31,174,31,174,30,72,31,94,31,64,31,64,30,227,31,204,31,41,31,41,30,166,31,254,31,237,31,8,31,170,31,141,31,183,31,208,31,56,31,8,31,79,31,73,31,229,31,224,31,160,31,53,31,95,31,183,31,29,31,29,30,213,31,218,31,167,31,167,30,168,31,168,30,168,29,202,31,110,31,173,31,173,30,165,31,60,31,60,30,61,31,176,31,145,31,145,30,67,31,67,30,68,31,175,31,61,31,106,31,106,30,169,31,184,31,117,31,117,30,66,31,129,31,112,31,72,31,62,31,231,31,13,31,13,30,30,31,120,31,124,31,165,31,227,31,47,31,107,31,155,31,41,31,71,31,71,30,51,31,132,31,132,30,113,31,11,31,101,31,83,31,83,30,83,29,242,31,255,31,255,30,255,29,237,31,184,31,93,31,232,31,45,31,45,30,45,29,56,31,56,30,253,31,44,31,235,31,18,31,18,30,137,31,225,31,225,30,126,31,31,31,59,31,61,31,184,31,184,30,183,31,183,30,58,31,28,31,57,31,57,30,57,31,94,31,94,30,200,31,120,31,150,31,221,31,102,31,192,31,40,31,17,31,250,31,174,31,47,31,47,30,47,29,192,31,23,31,30,31,30,30,186,31,48,31,217,31,25,31,25,30,80,31,246,31,246,30,18,31,12,31,57,31,220,31,22,31,22,30,119,31,100,31,254,31,254,30,254,29,223,31,175,31,175,30,2,31,72,31,72,30,167,31,105,31,223,31,139,31,143,31,158,31,59,31,59,30,103,31,126,31,183,31,223,31,51,31,74,31,74,30,102,31,102,30,173,31,213,31,213,30,225,31,42,31,82,31,177,31,31,31,246,31,179,31,102,31,62,31,73,31,83,31,101,31,101,30,125,31,153,31,235,31,64,31,218,31,66,31,146,31,146,30,46,31,79,31,15,31,15,30,132,31,127,31,127,30,168,31,42,31,112,31,205,31,226,31,117,31,72,31,240,31,229,31,157,31,84,31,114,31,203,31,203,30,206,31,16,31,174,31,148,31,118,31,132,31,58,31,78,31,78,30,82,31,234,31,119,31,97,31,97,30,239,31,40,31,255,31,32,31,250,31,179,31,144,31,45,31,7,31,218,31,81,31,141,31,220,31,214,31,203,31,138,31,138,30,136,31,125,31,121,31,121,30,104,31,104,30,255,31,181,31,180,31,20,31,20,30,20,29,3,31,2,31,209,31,249,31,249,30,254,31,254,30,55,31,55,30,21,31,21,30,83,31,252,31,249,31,110,31,229,31,128,31,112,31,28,31,182,31,182,30,248,31,64,31,28,31,18,31,93,31,51,31,51,30,213,31,213,30,173,31,99,31,138,31,127,31,215,31,20,31,54,31,199,31,72,31,190,31,95,31,142,31,142,30,36,31,30,31,3,31,1,31,15,31,32,31,6,31,6,30,91,31,104,31,199,31,135,31,57,31,42,31,35,31,227,31,83,31,7,31,6,31,6,30,55,31,209,31,77,31,31,31,31,30,164,31,28,31,61,31,7,31,84,31,180,31,199,31,46,31,46,30,46,29,55,31,55,30,224,31);

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
